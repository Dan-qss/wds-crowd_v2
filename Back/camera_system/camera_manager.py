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
        """Initialize a single camera with proper error isolation and improved connection handling"""
        try:
            camera_id = str(camera['camera_id'])
            
            # Handle field names from database
            name = camera.get('name') or camera.get('zone_name', 'Unknown')
            ip = camera.get('ip') or camera.get('ip_address', '')
            
            self.logger.info(f"Initializing camera {camera_id} ({name}) at IP: {ip}")
            
            # Initialize basic structures for this camera regardless of connection status
            self.frame_queues[camera_id] = Queue(maxsize=10)
            self.locks[camera_id] = Lock()
            self.running[camera_id] = False
            self.cameras[camera_id] = camera
            
            # Attempt to connect to the camera with a timeout
            try:
                # Set a timeout for the connection
                client = Client(
                    f"http://{ip}",
                    camera['username'],
                    camera['password']
                )
                
                # Test connection with explicit timeout (implemented by requests library)
                # If available in your Client implementation, set a timeout parameter
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
        """
        Handle the camera streaming process with enhanced reconnection logic 
        that properly detects camera reboots and network interruptions
        """
        camera_name = self.cameras[camera_id].get('name', camera_id)
        retry_interval = self.camera_config.get('retry_interval', 5)  # seconds
        max_consecutive_errors = self.camera_config.get('max_consecutive_errors', 3)
        consecutive_errors = 0
        last_reconnect_attempt = 0
        reconnect_timeout = 10  # seconds between full connection resets
        
        while self.running[camera_id]:
            try:
                current_time = time.time()
                
                # This is the critical part: Always force a full reconnection if the client has been failing
                # for a while, which handles cases where the camera was rebooted
                if ((self.clients[camera_id] is None) or consecutive_errors >= max_consecutive_errors) and \
                (current_time - last_reconnect_attempt > reconnect_timeout):
                    
                    last_reconnect_attempt = current_time
                    self.logger.info(f"Attempting full reconnection for camera {camera_id} ({camera_name})")
                    
                    try:
                        # Completely close any existing client resources
                        if self.clients[camera_id] is not None:
                            try:
                                # Attempt to properly close the connection
                                # This varies based on the Hikvision client implementation
                                # If there's a specific close/disconnect method, use it here
                                self.clients[camera_id] = None
                            except Exception as e:
                                self.logger.debug(f"Error closing old client for camera {camera_id}: {str(e)}")
                        
                        # Create a fresh client connection
                        camera = self.cameras[camera_id]
                        ip = camera.get('ip') or camera.get('ip_address', '')
                        
                        # Print debug info
                        self.logger.debug(f"Reconnecting to camera at IP: {ip}")
                        
                        # Create a new client with a fresh connection
                        client = Client(
                            f"http://{ip}",
                            camera['username'],
                            camera['password']
                        )
                        
                        # Test connection with explicit timeout
                        response = client.System.deviceInfo(method='get')
                        if response is not None:
                            self.clients[camera_id] = client
                            self.logger.info(f"Successfully reconnected to camera {camera_id} ({camera_name})")
                            consecutive_errors = 0
                            # Continue to the frame capture logic to start streaming immediately
                        else:
                            raise Exception("Received null response from camera")
                            
                    except Exception as e:
                        self.logger.error(f"Failed to reconnect to camera {camera_id} ({camera_name}): {str(e)}")
                        self.clients[camera_id] = None  # Ensure client is nullified on error
                        time.sleep(retry_interval)
                        continue
                
                # Skip the rest of the loop if client is None
                if self.clients[camera_id] is None:
                    time.sleep(retry_interval)
                    continue
                    
                # Get a frame
                try:
                    client = self.clients[camera_id]
                    response = client.Streaming.channels[1].picture(method='get', type='opaque_data')
                    
                    if response is None or not hasattr(response, 'content') or not response.content:
                        raise Exception("Invalid response from camera")
                        
                    frame_data = np.frombuffer(response.content, dtype=np.uint8)
                    frame = cv2.imdecode(frame_data, cv2.IMREAD_COLOR)
                    
                    if frame is not None:
                        # Add frame to queue
                        with self.locks[camera_id]:
                            if self.frame_queues[camera_id].full():
                                self.frame_queues[camera_id].get()
                            self.frame_queues[camera_id].put(frame)
                        
                        consecutive_errors = 0
                        time.sleep(1/30)  # 30 FPS limit
                    else:
                        raise Exception("Decoded frame is None")
                        
                except Exception as e:
                    consecutive_errors += 1
                    self.logger.error(f"Failed to get frame from camera {camera_id} ({camera_name}), consecutive errors: {consecutive_errors}: {str(e)}")
                    
                    if consecutive_errors >= max_consecutive_errors:
                        self.logger.warning(f"Multiple consecutive errors for camera {camera_id} ({camera_name}), forcing reconnection")
                        self.clients[camera_id] = None  # Force reconnection on next loop
                    
                    time.sleep(1)  # Short sleep after error
                    
            except Exception as e:
                self.logger.error(f"Unexpected error in stream loop for camera {camera_id} ({camera_name}): {str(e)}")
                consecutive_errors += 1
                time.sleep(1)
                    
            except Exception as e:
                self.logger.error(f"Unexpected error in stream loop for camera {camera_id} ({camera_name}): {str(e)}")
                time.sleep(1)

    def force_reconnect_camera(self, camera_id: str) -> bool:
        """
        Force a camera to attempt reconnection regardless of its current status.
        This is useful after a camera reboot or network interruption.
        
        Args:
            camera_id: The ID of the camera to reconnect
            
        Returns:
            bool: True if camera was found and reset for reconnection, False otherwise
        """
        try:
            if camera_id not in self.cameras:
                self.logger.error(f"Camera {camera_id} not found for forced reconnection")
                return False
                
            self.logger.info(f"Forcing reconnection for camera {camera_id}")
            
            # Remove existing client
            if camera_id in self.clients:
                # Try to clean up old client if possible
                try:
                    # If there's a specific method to close the connection, call it here
                    pass
                except Exception as e:
                    self.logger.debug(f"Error closing old client for camera {camera_id}: {str(e)}")
                
                # Set to None to trigger reconnection in the streaming thread
                self.clients[camera_id] = None
            
            # If camera is not already running, start it
            if not self.running.get(camera_id, False):
                return self.start_camera(camera_id)
                
            return True
        except Exception as e:
            self.logger.error(f"Error during forced reconnection for camera {camera_id}: {str(e)}")
            return False
    
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