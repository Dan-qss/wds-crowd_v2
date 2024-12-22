import asyncio
import websockets
import cv2
import base64
import json
import logging
from threading import Thread, Lock
from queue import Queue
import numpy as np
import zlib
from websockets.exceptions import ConnectionClosed, ConnectionClosedError

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

class WebSocketStreamer:
    def __init__(self, camera_ids=["1", "2", "3", "4", "5"]):
        self.camera_ids = camera_ids
        self.connections = set()
        self.connections_lock = Lock()
        self.frame_queues = {
            cam_id: Queue(maxsize=1) for cam_id in camera_ids
        }
        self.crowding_status = {
            cam_id: {"status": "Unknown"} for cam_id in camera_ids
        }
        self.running = True
        self.broadcast_task = None
        self.compression_level = 6  # Adjust compression level (1-9)
        self.quality = 70  # Reduce JPEG quality for smaller size

    async def register(self, websocket):
        """Register a new WebSocket connection"""
        with self.connections_lock:
            self.connections.add(websocket)
            logger.info(f"New connection added. Total connections: {len(self.connections)}")
        
        try:
            # Send initial configuration and current status
            await websocket.send(json.dumps({
                'type': 'config',
                'cameras': self.camera_ids,
                'initial_status': self.crowding_status
            }))
            
            # Keep the connection alive with ping/pong
            while self.running:
                try:
                    message = await websocket.recv()
                    if message == "ping":
                        await websocket.send("pong")
                except (ConnectionClosed, ConnectionClosedError):
                    break
                except Exception as e:
                    logger.error(f"Error in connection: {str(e)}")
                    break
                    
        finally:
            with self.connections_lock:
                self.connections.discard(websocket)
                logger.info(f"Connection removed. Total connections: {len(self.connections)}")

    async def broadcast_frames(self):
        """Main broadcast loop"""
        while self.running:
            try:
                for camera_id in self.camera_ids:
                    if not self.frame_queues[camera_id].empty():
                        frame = self.frame_queues[camera_id].get_nowait()
                        
                        if len(self.connections) == 0:
                            continue

                        try:
                            # Resize frame if too large
                            height, width = frame.shape[:2]
                            if width > 1280:  # Limit max width
                                scale = 1280 / width
                                frame = cv2.resize(frame, (1280, int(height * scale)))

                            # Encode frame with reduced quality
                            _, buffer = cv2.imencode('.jpg', frame, [
                                cv2.IMWRITE_JPEG_QUALITY, self.quality
                            ])
                            frame_data = buffer.tobytes()
                            
                            # Compress the frame data
                            compressed_data = zlib.compress(frame_data, self.compression_level)
                            frame_base64 = base64.b64encode(compressed_data).decode('utf-8')
                            
                            message = json.dumps({
                                'type': 'frame',
                                'camera_id': camera_id,
                                'frame': frame_base64,
                                'compressed': True,
                                'status': self.crowding_status[camera_id]
                            })

                            # Broadcast frame
                            disconnected = set()
                            for websocket in self.connections.copy():
                                try:
                                    await websocket.send(message)
                                except Exception as e:
                                    logger.error(f"Error sending frame: {str(e)}")
                                    disconnected.add(websocket)
                            
                            # Remove disconnected clients
                            with self.connections_lock:
                                for websocket in disconnected:
                                    self.connections.discard(websocket)

                        except Exception as e:
                            logger.error(f"Error processing frame: {str(e)}")
                            continue

                await asyncio.sleep(1/30)  # 30 FPS limit
                
            except Exception as e:
                logger.error(f"Broadcast error: {str(e)}")
                await asyncio.sleep(0.1)

    def update_frame(self, camera_id, frame, data=None):
        """Update frame and crowding status for a specific camera"""
        if not self.running:
            return
            
        try:
            # Update crowding status if provided
            if data is not None:
                self.crowding_status[camera_id] = data

            # Update frame
            if self.frame_queues[camera_id].full():
                try:
                    self.frame_queues[camera_id].get_nowait()
                except:
                    pass
            self.frame_queues[camera_id].put(frame)
            
        except Exception as e:
            logger.error(f"Error updating frame: {str(e)}")

    async def start_server(self):
        """Start WebSocket server"""
        try:
            self.broadcast_task = asyncio.create_task(self.broadcast_frames())
            
            async with websockets.serve(
                self.register, 
                "localhost", 
                8765,
                ping_interval=None,  # Disable automatic ping
                ping_timeout=None,   # Disable ping timeout
                max_size=None,       # No message size limit
                compression=None,    # Handle compression manually
                max_queue=32         # Limit message queue
            ) as server:
                await asyncio.Future()  # run forever
        finally:
            self.running = False
            if self.broadcast_task:
                self.broadcast_task.cancel()

    def run(self):
        """Run the WebSocket server"""
        try:
            asyncio.run(self.start_server())
        except KeyboardInterrupt:
            logger.info("Received interrupt signal")
        finally:
            self.running = False

    def stop(self):
        """Stop the WebSocket server"""
        self.running = False
        if self.broadcast_task:
            self.broadcast_task.cancel()