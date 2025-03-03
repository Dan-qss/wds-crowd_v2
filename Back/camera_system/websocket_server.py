import asyncio
import websockets
import cv2
import base64
import json
import logging
from threading import Thread, Lock
from queue import Queue, Empty
import numpy as np
import zlib
import os
from websockets.exceptions import ConnectionClosed, ConnectionClosedError
import time

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

# Set up console logging
console = logging.StreamHandler()
console.setLevel(logging.INFO)
formatter = logging.Formatter('%(asctime)s - %(name)s - %(levelname)s - %(message)s')
console.setFormatter(formatter)
logger.addHandler(console)

class WebSocketStreamer:
    def __init__(self, camera_ids=["1", "2", "3", "4", "5"]):
        self.camera_ids = camera_ids
        self.connections = set()
        self.connections_lock = Lock()
        self.frame_queues = {
            cam_id: Queue(maxsize=1) for cam_id in camera_ids
        }
        self.crowding_status = {
            cam_id: {"status": "Unknown", "crowding_percentage": 10, "crowding_level": "Low"} for cam_id in camera_ids
        }
        self.camera_last_update = {
            cam_id: 0 for cam_id in camera_ids
        }
        self.camera_available = {
            cam_id: True for cam_id in camera_ids
        }
        self.running = True
        self.broadcast_task = None
        self.compression_level = 6
        self.quality = 95
        self.max_frame_age = 5.0  # seconds
        
        # Always enable debug mode for now
        self.debug = True
        print(f"WebSocketStreamer initialized with camera IDs: {camera_ids}")

    async def register(self, websocket):
        client_ip = websocket.remote_address[0] if hasattr(websocket, 'remote_address') else 'unknown'
        print(f"New client connected from {client_ip}")
        
        with self.connections_lock:
            self.connections.add(websocket)
        
        try:
            # Send initial configuration with camera availability
            config_message = {
                'type': 'config',
                'cameras': self.camera_ids,
                'initial_status': self.crowding_status,
                'camera_available': self.camera_available
            }
            
            print(f"Sending config to new client: {json.dumps(config_message)}")
            await websocket.send(json.dumps(config_message))
            
            # Send a ping immediately to check connection
            await websocket.send(json.dumps({"type": "ping", "timestamp": time.time()}))
            
            while self.running:
                try:
                    message = await websocket.recv()
                    if message == "ping":
                        await websocket.send("pong")
                    elif message == "pong":
                        # Client responds to our ping
                        pass
                    elif message.startswith("get_status"):
                        # Client requested status update
                        status_message = {
                            'type': 'status_update',
                            'camera_status': self.crowding_status,
                            'camera_available': self.camera_available
                        }
                        
                        print(f"Sending status update: {json.dumps(status_message)}")
                        await websocket.send(json.dumps(status_message))
                except (ConnectionClosed, ConnectionClosedError):
                    print(f"Client {client_ip} disconnected normally")
                    break
                except Exception as e:
                    logger.error(f"Error in websocket connection: {str(e)}")
                    print(f"WebSocket error with client {client_ip}: {str(e)}")
                    break
                    
        finally:
            with self.connections_lock:
                self.connections.discard(websocket)
                print(f"Client {client_ip} removed from connections. Active connections: {len(self.connections)}")

    async def broadcast_frames(self):
        frame_count = {cam_id: 0 for cam_id in self.camera_ids}
        last_log_time = time.time()
        
        while self.running:
            try:
                current_time = time.time()
                
                # Log frame stats every 10 seconds if in debug mode
                if current_time - last_log_time > 10:
                    print(f"Frame count in last 10s: {frame_count}")
                    print(f"Active connections: {len(self.connections)}")
                    frame_count = {cam_id: 0 for cam_id in self.camera_ids}
                    last_log_time = current_time
                
                # Check for stale frames (cameras that haven't updated recently)
                for camera_id in self.camera_ids:
                    if current_time - self.camera_last_update[camera_id] > self.max_frame_age:
                        if self.camera_available[camera_id]:
                            logger.warning(f"Camera {camera_id} hasn't updated for {self.max_frame_age} seconds, marking as unavailable")
                            print(f"Camera {camera_id} hasn't updated for {self.max_frame_age} seconds, marking as unavailable")
                            self.camera_available[camera_id] = False
                            
                            # Notify clients of camera unavailability
                            if len(self.connections) > 0:
                                try:
                                    message = json.dumps({
                                        'type': 'camera_status',
                                        'camera_id': camera_id,
                                        'available': False
                                    })
                                    await self.broadcast_message(message)
                                except Exception as e:
                                    logger.error(f"Error sending camera unavailability: {str(e)}")
                
                # Skip broadcasting if no connections
                if len(self.connections) == 0:
                    await asyncio.sleep(0.1)
                    continue
                
                for camera_id in self.camera_ids:
                    try:
                        # Only process if frame queue is not empty
                        if not self.frame_queues[camera_id].empty():
                            frame = None
                            try:
                                frame = self.frame_queues[camera_id].get_nowait()
                            except Empty:
                                continue
                                
                            if frame is None:
                                continue
                            
                            # Mark camera as available if we got a frame
                            if not self.camera_available[camera_id]:
                                print(f"Camera {camera_id} is now available")
                                self.camera_available[camera_id] = True
                                # Notify clients
                                message = json.dumps({
                                    'type': 'camera_status',
                                    'camera_id': camera_id,
                                    'available': True
                                })
                                await self.broadcast_message(message)

                            # Get frame dimensions
                            height, width = frame.shape[:2]
                            new_height, new_width = height, width

                            # Resize if width is too large
                            if width > 1280:
                                scale = 1280 / width
                                frame = cv2.resize(frame, (1280, int(height * scale)))
                                # Update resolution variables
                                new_height, new_width = frame.shape[:2]

                            # Encode and compress frame
                            _, buffer = cv2.imencode('.jpg', frame, [
                                cv2.IMWRITE_JPEG_QUALITY, self.quality
                            ])
                            frame_data = buffer.tobytes()
                            compressed_data = zlib.compress(frame_data, self.compression_level)
                            frame_base64 = base64.b64encode(compressed_data).decode('utf-8')
                            
                            # Count frames for debugging
                            frame_count[camera_id] += 1
                            
                            # Add default crowding status if not set
                            if camera_id not in self.crowding_status:
                                self.crowding_status[camera_id] = {
                                    "status": "Unknown", 
                                    "crowding_percentage": 10, 
                                    "crowding_level": "Low"
                                }
                            
                            message = json.dumps({
                                'type': 'frame',
                                'camera_id': camera_id,
                                'frame': frame_base64,
                                'compressed': True,
                                'status': self.crowding_status[camera_id],
                                'resolution': {
                                    'width': new_width,
                                    'height': new_height
                                }
                            })

                            await self.broadcast_message(message)
                    except Exception as e:
                        logger.error(f"Error processing frame for camera {camera_id}: {str(e)}")
                        print(f"Error processing frame for camera {camera_id}: {str(e)}")
                        continue

                await asyncio.sleep(1/30)  # 30 FPS limit
                
            except Exception as e:
                logger.error(f"Error in broadcast loop: {str(e)}")
                print(f"Error in broadcast loop: {str(e)}")
                await asyncio.sleep(0.1)

    async def broadcast_message(self, message):
        """Broadcast a message to all connected clients with error handling"""
        if len(self.connections) == 0:
            return
            
        disconnected = set()
        for websocket in self.connections.copy():
            try:
                await websocket.send(message)
            except Exception as e:
                logger.error(f"Error sending message to client: {str(e)}")
                print(f"Error sending message to client: {str(e)}")
                disconnected.add(websocket)
        
        # Clean up disconnected clients
        if disconnected:
            with self.connections_lock:
                for websocket in disconnected:
                    self.connections.discard(websocket)
                    print(f"Removed disconnected client. Active connections: {len(self.connections)}")

    def update_frame(self, camera_id, frame, data=None):
        """Update frame for a specific camera with timestamp tracking"""
        if not self.running or camera_id not in self.frame_queues:
            return
            
        try:
            # Update status data if provided
            if data is not None:
                self.crowding_status[camera_id] = data
            # Default status data if none was provided
            elif camera_id not in self.crowding_status:
                self.crowding_status[camera_id] = {
                    "status": "Unknown", 
                    "crowding_percentage": 10, 
                    "crowding_level": "Low"
                }

            # Update frame
            if frame is not None:
                # Clear queue if full
                if self.frame_queues[camera_id].full():
                    try:
                        self.frame_queues[camera_id].get_nowait()
                    except Empty:
                        pass
                        
                self.frame_queues[camera_id].put(frame)
                
                # Update timestamp of last frame received
                self.camera_last_update[camera_id] = time.time()
                
                if camera_id == "1" and time.time() % 5 < 0.1:  # Log only occasionally
                    print(f"Updated frame for camera {camera_id}, shape: {frame.shape}")
                
        except Exception as e:
            logger.error(f"Error updating frame for camera {camera_id}: {str(e)}")
            print(f"Error updating frame for camera {camera_id}: {str(e)}")

    async def start_server(self):
        try:
            # Always use 0.0.0.0 to listen on all interfaces
            server_ip = "0.0.0.0"
            server_port = int(os.environ.get('WEBSOCKET_SERVER_PORT', 8765))
            
            print(f"Starting WebSocket server on {server_ip}:{server_port}")
                
            self.broadcast_task = asyncio.create_task(self.broadcast_frames())
            
            async with websockets.serve(
                self.register, 
                server_ip, 
                server_port,
                ping_interval=30,  # Send ping every 30 seconds
                ping_timeout=10,  # Wait 10 seconds for pong
                max_size=None,
                compression=None,
                max_queue=32
            ) as server:
                print(f"WebSocket server started on {server_ip}:{server_port}")
                print("Waiting for connections...")
                await asyncio.Future()
        except Exception as e:
            logger.error(f"Error starting websocket server: {str(e)}")
            print(f"Error starting websocket server: {str(e)}")
            raise
        finally:
            self.running = False
            if self.broadcast_task:
                self.broadcast_task.cancel()

    def run(self):
        try:
            asyncio.run(self.start_server())
        except KeyboardInterrupt:
            print("WebSocket server stopped by keyboard interrupt")
        except Exception as e:
            logger.error(f"Fatal error in websocket server: {str(e)}")
            print(f"Fatal error in websocket server: {str(e)}")
        finally:
            self.running = False

    def stop(self):
        """Stop the server gracefully"""
        print("Stopping WebSocket server...")
        self.running = False
        if self.broadcast_task:
            self.broadcast_task.cancel()