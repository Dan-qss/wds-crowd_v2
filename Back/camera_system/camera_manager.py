# Back/camera_system/camera_manager.py
import cv2
import time
import logging
import numpy as np
from threading import Thread, Lock
from queue import Queue
from typing import Dict, Optional
from hikvisionapi import Client
import sys
import os

# Add parent directory to Python path
sys.path.append(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
from database.camera_system_database.db_connector import DatabaseConnector
from database.camera_system_database.db_config import DB_CONFIG

# Set up error logging
log_dir = os.path.join(os.path.dirname(os.path.dirname(os.path.abspath(__file__))), 'logs')
if not os.path.exists(log_dir):
    os.makedirs(log_dir)

error_log_path = os.path.join(log_dir, 'errors.log')
logging.basicConfig(
    filename=error_log_path,
    level=logging.ERROR,
    format='%(asctime)s - %(name)s - %(levelname)s - %(message)s'
)

class CameraManager:
    def __init__(self):
        self.cameras: Dict[str, dict] = {}
        self.clients: Dict[str, Client] = {}
        self.frame_queues: Dict[str, Queue] = {}
        self.running: Dict[str, bool] = {}
        self.threads: Dict[str, Thread] = {}
        self.locks: Dict[str, Lock] = {}
        
        self.logger = logging.getLogger(__name__)
        
        # Initialize database and configurations
        try:
            self.db = DatabaseConnector(**DB_CONFIG)
            
            # Get camera configurations first
            self.camera_config = self.db.get_camera_config()
            if not self.camera_config:
                self.logger.error("No camera configuration found in database")
                # Instead of raising an exception, set a default configuration
                self.camera_config = {'max_retries': 3}
                
            self._initialize_cameras()
        except Exception as e:
            self.logger.error(f"Error in CameraManager initialization: {str(e)}")
            # Set a default configuration if database connection fails
            self.camera_config = {'max_retries': 3}

    def _initialize_cameras(self):
        """Initialize all enabled cameras independently"""
        try:
            enabled_cameras = self.db.get_enabled_cameras()
            
            if not enabled_cameras:
                self.logger.error("No enabled cameras found in database")
                return
                
            for camera in enabled_cameras:
                self._initialize_single_camera(camera)
                
        except Exception as e:
            self.logger.error(f"Error retrieving enabled cameras: {str(e)}")

    def _initialize_single_camera(self, camera):
        """Initialize a single camera with proper error isolation"""
        try:
            camera_id = str(camera['camera_id'])
            
            # Handle field names from database
            name = camera.get('name') or camera.get('zone_name', 'Unknown')
            ip = camera.get('ip') or camera.get('ip_address', '')
            
            # Initialize basic structures for this camera regardless of connection status
            self.frame_queues[camera_id] = Queue(maxsize=10)
            self.locks[camera_id] = Lock()
            self.running[camera_id] = False
            self.cameras[camera_id] = camera
            
            # Attempt to connect to the camera
            try:
                client = Client(
                    f"http://{ip}",
                    camera['username'],
                    camera['password']
                )
                
                # Test connection
                client.System.deviceInfo(method='get')
                self.clients[camera_id] = client
                self.logger.info(f"Successfully initialized camera {camera_id} ({name})")
            except Exception as e:
                # If connection fails, log error but don't affect other cameras
                self.logger.error(f"Failed to connect to camera {camera_id} ({name}): {str(e)}")
                # Keep camera in the list but mark as not connected
                if camera_id not in self.clients:
                    self.clients[camera_id] = None
                
        except Exception as e:
            self.logger.error(f"Error in camera initialization for camera ID {camera.get('camera_id', 'unknown')}: {str(e)}")

    def _stream_camera(self, camera_id: str):
        """Handle the camera streaming process with independent error handling"""
        retries = 0
        max_retries = self.camera_config.get('max_retries', 3)
        retry_interval = self.camera_config.get('retry_interval', 5)  # seconds
        camera_name = self.cameras[camera_id].get('name', camera_id)
        
        while self.running[camera_id]:
            try:
                # Skip if client is None (not connected)
                if self.clients[camera_id] is None:
                    self.logger.warning(f"Camera {camera_id} ({camera_name}) not connected, retrying...")
                    # Try to reconnect
                    try:
                        camera = self.cameras[camera_id]
                        ip = camera.get('ip') or camera.get('ip_address', '')
                        
                        client = Client(
                            f"http://{ip}",
                            camera['username'],
                            camera['password']
                        )
                        
                        # Test connection
                        client.System.deviceInfo(method='get')
                        self.clients[camera_id] = client
                        self.logger.info(f"Successfully reconnected to camera {camera_id} ({camera_name})")
                        retries = 0
                    except Exception as e:
                        retries += 1
                        self.logger.error(f"Failed to reconnect to camera {camera_id} ({camera_name}), attempt {retries}/{max_retries}: {str(e)}")
                        # Sleep before retrying
                        time.sleep(retry_interval)
                        continue
                
                client = self.clients[camera_id]
                
                # Get a frame
                try:
                    response = client.Streaming.channels[1].picture(method='get', type='opaque_data')
                    frame_data = np.frombuffer(response.content, dtype=np.uint8)
                    frame = cv2.imdecode(frame_data, cv2.IMREAD_COLOR)
                    
                    if frame is not None:
                        # Add frame to queue
                        with self.locks[camera_id]:
                            if self.frame_queues[camera_id].full():
                                self.frame_queues[camera_id].get()
                            self.frame_queues[camera_id].put(frame)
                        
                        retries = 0
                        time.sleep(1/30)  # 30 FPS limit
                    else:
                        raise Exception("Decoded frame is None")
                        
                except Exception as e:
                    retries += 1
                    self.logger.error(f"Failed to get frame from camera {camera_id} ({camera_name}), attempt {retries}/{max_retries}: {str(e)}")
                    
                    if retries >= max_retries:
                        self.logger.error(f"Max retries reached for camera {camera_id} ({camera_name}), marking as disconnected")
                        self.clients[camera_id] = None
                        retries = 0
                        time.sleep(retry_interval)
                    else:
                        time.sleep(1)
                    
            except Exception as e:
                self.logger.error(f"Unexpected error in stream loop for camera {camera_id} ({camera_name}): {str(e)}")
                time.sleep(1)

    def get_frame(self, camera_id: str) -> Optional[np.ndarray]:
        """Get the latest frame from a camera queue"""
        try:
            if camera_id in self.frame_queues and not self.frame_queues[camera_id].empty():
                return self.frame_queues[camera_id].get()
        except Exception as e:
            self.logger.error(f"Error getting frame from camera {camera_id}: {str(e)}")
        return None

    def start_camera(self, camera_id: str) -> bool:
        """Start streaming for a specific camera"""
        if camera_id not in self.cameras:
            self.logger.error(f"Camera {camera_id} not found in configuration")
            return False

        # Skip if already running
        if self.running.get(camera_id, False):
            return True

        try:
            # Mark as running and start thread
            self.running[camera_id] = True
            thread = Thread(target=self._stream_camera, args=(camera_id,))
            thread.daemon = True
            self.threads[camera_id] = thread
            thread.start()
            return True
        except Exception as e:
            self.logger.error(f"Error starting camera {camera_id}: {str(e)}")
            self.running[camera_id] = False
            return False

    def start_all_cameras(self):
        """Start all cameras independently"""
        for camera_id in self.cameras:
            try:
                self.start_camera(camera_id)
            except Exception as e:
                self.logger.error(f"Error starting camera {camera_id}: {str(e)}")
                # Continue with other cameras

    def stop_camera(self, camera_id: str):
        """Stop a specific camera"""
        try:
            if camera_id in self.running:
                self.running[camera_id] = False
                if camera_id in self.threads and self.threads[camera_id].is_alive():
                    self.threads[camera_id].join(timeout=2.0)  # Timeout to prevent hanging
                    if self.threads[camera_id].is_alive():
                        self.logger.warning(f"Thread for camera {camera_id} did not terminate gracefully")
                    else:
                        del self.threads[camera_id]
        except Exception as e:
            self.logger.error(f"Error stopping camera {camera_id}: {str(e)}")

    def stop_all_cameras(self):
        """Stop all cameras"""
        camera_ids = list(self.running.keys())
        for camera_id in camera_ids:
            try:
                self.stop_camera(camera_id)
            except Exception as e:
                self.logger.error(f"Error stopping camera {camera_id}: {str(e)}")

    def get_camera_status(self, camera_id: str) -> dict:
        """Get status of a specific camera"""
        try:
            return {
                'running': self.running.get(camera_id, False),
                'connected': camera_id in self.clients and self.clients[camera_id] is not None,
                'queue_size': self.frame_queues[camera_id].qsize() if camera_id in self.frame_queues else 0,
                'name': self.cameras[camera_id]['name'] if camera_id in self.cameras else None
            }
        except Exception as e:
            self.logger.error(f"Error getting status for camera {camera_id}: {str(e)}")
            return {
                'running': False,
                'connected': False,
                'queue_size': 0,
                'name': None,
                'error': str(e)
            }