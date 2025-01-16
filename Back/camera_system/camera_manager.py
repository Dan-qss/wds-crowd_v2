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
        self.db = DatabaseConnector(**DB_CONFIG)
        
        # Get camera configurations first
        self.camera_config = self.db.get_camera_config()
        if not self.camera_config:
            self.logger.error("No camera configuration found in database")
            raise ValueError("No camera configuration found in database")
            
        self._initialize_cameras()

    def _initialize_cameras(self):
        """Initialize all enabled cameras"""
        enabled_cameras = self.db.get_enabled_cameras()
        
        for camera in enabled_cameras:
            try:
                camera_id = str(camera['camera_id'])
                
                # Handle field names from database
                name = camera.get('name') or camera.get('zone_name', 'Unknown')
                ip = camera.get('ip') or camera.get('ip_address', '')
                
                client = Client(
                    f"http://{ip}",
                    camera['username'],
                    camera['password']
                )
                
                try:
                    client.System.deviceInfo(method='get')
                    self.clients[camera_id] = client
                    self.cameras[camera_id] = camera
                    self.frame_queues[camera_id] = Queue(maxsize=10)
                    self.locks[camera_id] = Lock()
                    self.running[camera_id] = False
                except Exception as e:
                    self.logger.error(f"Failed to connect to camera {camera_id}: {str(e)}")
                    
            except Exception as e:
                self.logger.error(f"Error initializing camera {camera_id}: {str(e)}")

    def _stream_camera(self, camera_id: str):
        """Handle the camera streaming process"""
        retries = 0
        max_retries = self.camera_config.get('max_retries', 3)
        
        while self.running[camera_id] and retries < max_retries:
            try:
                client = self.clients[camera_id]
                
                while self.running[camera_id]:
                    try:
                        response = client.Streaming.channels[1].picture(method='get', type='opaque_data')
                        frame_data = np.frombuffer(response.content, dtype=np.uint8)
                        frame = cv2.imdecode(frame_data, cv2.IMREAD_COLOR)
                        #
                        if frame is not None:
                            # # Print original resolution
                            # height, width = frame.shape[:2]
                            # print(f"camera_manager - Camera {camera_id} original resolution: {width}x{height}")
                            
                            # resize_scale = self.camera_config.get('resize_scale', 0.75)
                            # if resize_scale != 1.0:
                            #     new_size = (
                            #         int(width * resize_scale),
                            #         int(height * resize_scale)
                            #     )
                            #     frame = cv2.resize(frame, new_size)
                            #     # Print resized resolution
                            #     print(f"camera_manager - Camera {camera_id} resized resolution: {new_size[0]}x{new_size[1]}")

                            with self.locks[camera_id]:
                                if self.frame_queues[camera_id].full():
                                    self.frame_queues[camera_id].get()
                                self.frame_queues[camera_id].put(frame)
                            
                            retries = 0
                            time.sleep(1/30)  # 30 FPS limit
                            
                    except Exception as e:
                        self.logger.error(f"Failed to get frame from camera {camera_id}: {str(e)}")
                        break
                        
            except Exception as e:
                self.logger.error(f"Error streaming camera {camera_id}: {str(e)}")
                retries += 1
                time.sleep(1)

        if retries >= max_retries:
            self.logger.error(f"Max retries reached for camera {camera_id}, stopping camera")
            self.running[camera_id] = False

    def get_frame(self, camera_id: str) -> Optional[np.ndarray]:
        if camera_id in self.frame_queues and not self.frame_queues[camera_id].empty():
            return self.frame_queues[camera_id].get()
        return None

    def start_camera(self, camera_id: str) -> bool:
        if camera_id not in self.cameras:
            self.logger.error(f"Camera {camera_id} not found in configuration")
            return False

        if self.running.get(camera_id, False):
            return True

        self.running[camera_id] = True
        thread = Thread(target=self._stream_camera, args=(camera_id,))
        thread.daemon = True
        self.threads[camera_id] = thread
        thread.start()
        return True

    def start_all_cameras(self):
        for camera_id in self.cameras:
            self.start_camera(camera_id)

    def stop_camera(self, camera_id: str):
        if camera_id in self.running:
            self.running[camera_id] = False
            if camera_id in self.threads:
                self.threads[camera_id].join()
                del self.threads[camera_id]

    def stop_all_cameras(self):
        camera_ids = list(self.running.keys())
        for camera_id in camera_ids:
            self.stop_camera(camera_id)

    def get_camera_status(self, camera_id: str) -> dict:
        return {
            'running': self.running.get(camera_id, False),
            'connected': camera_id in self.clients,
            'queue_size': self.frame_queues[camera_id].qsize() if camera_id in self.frame_queues else 0,
            'name': self.cameras[camera_id]['name'] if camera_id in self.cameras else None
        }