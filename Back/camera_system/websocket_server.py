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
import os
from websockets.exceptions import ConnectionClosed, ConnectionClosedError

# Set up error logging
BACK_DIR = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
log_dir = os.path.join(BACK_DIR, 'logs')

if not os.path.exists(log_dir):
    os.makedirs(log_dir)

error_log_path = os.path.join(log_dir, 'errors.log')
logging.basicConfig(
    filename=error_log_path,
    level=logging.ERROR,
    format='%(asctime)s - %(name)s - %(levelname)s - %(message)s'
)
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
        self.compression_level = 6
        self.quality = 95

    async def register(self, websocket):
        with self.connections_lock:
            self.connections.add(websocket)
        
        try:
            await websocket.send(json.dumps({
                'type': 'config',
                'cameras': self.camera_ids,
                'initial_status': self.crowding_status
            }))
            
            while self.running:
                try:
                    message = await websocket.recv()
                    if message == "ping":
                        await websocket.send("pong")
                except (ConnectionClosed, ConnectionClosedError):
                    break
                except Exception as e:
                    logger.error(f"Error in websocket connection: {str(e)}")
                    break
                    
        finally:
            with self.connections_lock:
                self.connections.discard(websocket)

    async def broadcast_frames(self):
        while self.running:
            try:
                for camera_id in self.camera_ids:
                    if not self.frame_queues[camera_id].empty():
                        frame = self.frame_queues[camera_id].get_nowait()
                        
                        if len(self.connections) == 0:
                            continue

                        try:
                            # Print original resolution
                            height, width = frame.shape[:2]
                            # print(f"WebSocket Server - Camera {camera_id} original resolution: {width}x{height}")

                            # Resize if width is too large
                            if width > 1280:
                                scale = 1280 / width
                                frame = cv2.resize(frame, (1280, int(height * scale)))
                                # Print resized resolution
                                new_height, new_width = frame.shape[:2]
                                # print(f"WebSocket Server - Camera {camera_id} resized resolution: {new_width}x{new_height}")

                            _, buffer = cv2.imencode('.jpg', frame, [
                                cv2.IMWRITE_JPEG_QUALITY, self.quality
                            ])
                            frame_data = buffer.tobytes()
                            
                            # Print compressed size
                            # print(f"WebSocket Server - Camera {camera_id} compressed size: {len(frame_data)} bytes")
                            
                            compressed_data = zlib.compress(frame_data, self.compression_level)
                            # Print final compressed size after zlib
                            # print(f"WebSocket Server - Camera {camera_id} final compressed size: {len(compressed_data)} bytes")
                            
                            frame_base64 = base64.b64encode(compressed_data).decode('utf-8')
                            
                            message = json.dumps({
                                'type': 'frame',
                                'camera_id': camera_id,
                                'frame': frame_base64,
                                'compressed': True,
                                'status': self.crowding_status[camera_id],
                                'resolution': {
                                    'width': new_width if width > 1280 else width,
                                    'height': new_height if width > 1280 else height
                                }
                            })

                            disconnected = set()
                            for websocket in self.connections.copy():
                                try:
                                    await websocket.send(message)
                                except Exception as e:
                                    logger.error(f"Error sending frame: {str(e)}")
                                    disconnected.add(websocket)
                            
                            with self.connections_lock:
                                for websocket in disconnected:
                                    self.connections.discard(websocket)

                        except Exception as e:
                            logger.error(f"Error processing frame for camera {camera_id}: {str(e)}")
                            continue

                await asyncio.sleep(1/30)
                
            except Exception as e:
                logger.error(f"Error in broadcast loop: {str(e)}")
                await asyncio.sleep(0.1)

    def update_frame(self, camera_id, frame, data=None):
        if not self.running:
            return
            
        try:
            if data is not None:
                self.crowding_status[camera_id] = data

            if self.frame_queues[camera_id].full():
                try:
                    self.frame_queues[camera_id].get_nowait()
                except:
                    pass
            self.frame_queues[camera_id].put(frame)
            
        except Exception as e:
            logger.error(f"Error updating frame for camera {camera_id}: {str(e)}")

    async def start_server(self):
        try:
            self.broadcast_task = asyncio.create_task(self.broadcast_frames())
            
            async with websockets.serve(
                self.register, 
                "localhost", 
                8765,
                ping_interval=None,
                ping_timeout=None,
                max_size=None,
                compression=None,
                max_queue=32
            ) as server:
                await asyncio.Future()
        except Exception as e:
            logger.error(f"Error starting websocket server: {str(e)}")
            raise
        finally:
            self.running = False
            if self.broadcast_task:
                self.broadcast_task.cancel()

    def run(self):
        try:
            asyncio.run(self.start_server())
        except KeyboardInterrupt:
            pass
        except Exception as e:
            logger.error(f"Fatal error in websocket server: {str(e)}")
        finally:
            self.running = False

    def stop(self):
        self.running = False
        if self.broadcast_task:
            self.broadcast_task.cancel()