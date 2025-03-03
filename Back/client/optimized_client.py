# Back/client/optimized_client.py
import sys
import os
sys.path.append(os.path.join(os.path.dirname(__file__), "../camera_system"))
import grpc
import camera_service_pb2
import camera_service_pb2_grpc
import cv2
import numpy as np
from queue import Queue
import queue
from threading import Thread
import time
from pathlib import Path
from ultralytics import YOLO
import torch
import logging
from datetime import datetime
import json

sys.path.append(os.path.dirname(os.path.dirname(__file__)))
from websocket_server import WebSocketStreamer
from database.camera_system_database.db_connector import DatabaseConnector
from database.camera_system_database.db_config import DB_CONFIG

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

# Import the model classes from separate files
from models.model1 import Model1
from models.model2 import Model2

class OptimizedCameraClient:
    def __init__(self, camera_ids=["1", "2", "3", "4", "5"]):
        try:
            self.camera_ids = camera_ids
            self.channel = grpc.insecure_channel(
                '127.0.0.1:50051',
                options=[
                    ('grpc.max_send_message_length', 100 * 1024 * 1024),
                    ('grpc.max_receive_message_length', 100 * 1024 * 1024),
                    ('grpc.enable_retries', 1),
                    ('grpc.keepalive_time_ms', 60000),
                    ('grpc.keepalive_timeout_ms', 20000),
                    ('grpc.keepalive_permit_without_calls', 1),
                    ('grpc.http2.max_pings_without_data', 5),
                    ('grpc.http2.min_time_between_pings_ms', 60000)
                ]
            )
            self.stub = camera_service_pb2_grpc.CameraServiceStub(self.channel)
            
            # Initialize database connection
            self.db = DatabaseConnector(**DB_CONFIG)
            
            # Get camera capacities from database
            enabled_cameras = self.db.get_enabled_cameras()
            self.camera_capacities = {
                str(cam['camera_id']): cam['capacities'] 
                for cam in enabled_cameras
            }
            
            # Initialize queues
            self.camera_queues = {
                cam_id: Queue(maxsize=1) for cam_id in camera_ids
            }
            
            # Initialize Model1 with database configuration
            self.model = Model1(self.db)
            self.model2 = Model2()
            
            self.running = True
            self.threads = []
            self.processing_times = {cam_id: [] for cam_id in camera_ids}
        except Exception as e:
            logger.error(f"Error initializing OptimizedCameraClient: {e}")
            raise

    def start_camera_stream(self, camera_id):
        try:
            request = camera_service_pb2.FrameRequest(camera_id=camera_id)
            for response in self.stub.StreamFrames(request):
                if not self.running:
                    break
                    
                frame_data = np.frombuffer(response.frame_data, dtype=np.uint8)
                frame = cv2.imdecode(frame_data, cv2.IMREAD_COLOR)
                
                if self.camera_queues[camera_id].full():
                    try:
                        self.camera_queues[camera_id].get_nowait()
                    except queue.Empty:
                        pass
                self.camera_queues[camera_id].put((frame, response.timestamp))
                
        except Exception as e:
            logger.error(f"Error in camera {camera_id} stream: {e}")

    def process_frames(self):
        try:
            websocket_streamer = WebSocketStreamer(self.camera_ids)
            websocket_thread = Thread(target=websocket_streamer.run)
            websocket_thread.daemon = True
            websocket_thread.start()
            
            frame_counters = {camera_id: 0 for camera_id in self.camera_ids}
            
            while self.running:
                for camera_id in self.camera_ids:
                    try:
                        frame, timestamp = self.camera_queues[camera_id].get_nowait()
                        frame_counters[camera_id] += 1
                        
                        # Get zone_name for this camera
                        camera_info = next(
                            (cam for cam in self.db.get_enabled_cameras() 
                             if str(cam['camera_id']) == camera_id),
                            None
                        )
                        zone_name = camera_info.get('zone_name') or camera_info.get('name', 'Unknown') if camera_info else 'Unknown'
                        
                        processed_frame, data = self.model.process(
                            frame, 
                            camera_id, 
                            self.camera_capacities[camera_id]
                        )
                        
                        # Process with other models - now including zone_name
                        self.model2.process(frame, camera_id, zone_name)
                        
                        data.update({
                            'name': zone_name
                        })
                        
                        websocket_streamer.update_frame(camera_id, processed_frame, data)
                        
                    except queue.Empty:
                        continue
                        
                if cv2.waitKey(1) & 0xFF == ord('q'):
                    break
                    
        except Exception as e:
            logger.error(f"Error processing frames: {e}")
        finally:
            websocket_streamer.stop()

    def run(self):
        try:
            for camera_id in self.camera_ids:
                thread = Thread(target=self.start_camera_stream, args=(camera_id,))
                thread.daemon = True
                thread.start()
                self.threads.append(thread)
            
            process_thread = Thread(target=self.process_frames)
            process_thread.daemon = True
            process_thread.start()
            self.threads.append(process_thread)
            
            while self.running:
                time.sleep(0.1)
                
        except KeyboardInterrupt:
            self.running = False
        except Exception as e:
            logger.error(f"Error in main run loop: {e}")
        finally:
            self.cleanup()

    def cleanup(self):
        try:
            self.running = False
            cv2.destroyAllWindows()
            self.channel.close()
        except Exception as e:
            logger.error(f"Error during cleanup: {e}")

def main():
    try:
        client = OptimizedCameraClient()
        client.run()
    except Exception as e:
        logger.error(f"Fatal error in main: {e}")

if __name__ == "__main__":
    main()