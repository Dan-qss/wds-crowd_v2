# Back/client/models/model1.py
import torch
import logging
from ultralytics import YOLO
import cv2
from roi import get_roi, draw_roi_on_frame
import numpy as np
from collections import defaultdict
from datetime import datetime
import time
from typing import List, Dict, Any
import sys
import os

back_dir = os.path.dirname(os.path.dirname(os.path.dirname(__file__)))
sys.path.append(back_dir)
from database.crowd_management_database.crowd_measurements import CrowdMeasurements

# Set up error logging
BACK_DIR = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
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

class Model1:
    def __init__(self, db_connector):
        try:
            self.model = YOLO('yolo11l.pt')
            self.db = db_connector
            
            self._init_cache()
            
            if torch.cuda.is_available():
                self.model = self.model.to('cuda')
                torch.backends.cudnn.benchmark = True
                torch.backends.cudnn.deterministic = False
                torch.cuda.set_device(0)
        except Exception as e:
            logger.error(f"Error initializing Model1: {e}")
            raise

    def _init_cache(self):
        try:
            enabled_cameras = self.db.get_enabled_cameras()
            
            self.camera_cache = {
                str(cam['camera_id']): {
                    'zone_name': cam['name'],
                    'area_name': cam['area_name'],
                    'capacity': cam['capacities']
                } for cam in enabled_cameras
            }
            
            self.camera_counts = {str(cam['camera_id']): 0 for cam in enabled_cameras}
            
            self.roi_cache = {}
            for camera_id in self.camera_counts.keys():
                roi = get_roi(camera_id)
                if roi and len(roi) > 2:
                    self.roi_cache[camera_id] = np.array(roi, dtype=np.int32).reshape((-1, 1, 2))
                else:
                    self.roi_cache[camera_id] = None
            
            self.current_minute_data = defaultdict(list)
            self.current_minute = self._get_current_minute()
        except Exception as e:
            logger.error(f"Error initializing cache: {e}")
            raise

    def _get_current_minute(self):
        try:
            return datetime.now().strftime('%Y-%m-%d %H:%M')
        except Exception as e:
            logger.error(f"Error getting current minute: {e}")
            return None

    def process(self, frame, camera_id, capacity):
        try:
            with torch.inference_mode():
                roi_np = self.roi_cache.get(camera_id)
                
                results = self.model(frame, conf=0.30, verbose=False, classes=[0], device=0)
                
                current_count = 0
                boxes = results[0].boxes
                for box in boxes:
                    x1, y1, x2, y2 = map(int, box.xyxy[0])
                    center_x = int((x1 + x2) / 2)
                    center_y = int((y1 + y2) / 2)
                    
                    if roi_np is not None and cv2.pointPolygonTest(roi_np, (center_x, center_y), False) >= 0:
                        color = (0, 0, 255)
                        current_count += 1
                    else:
                        color = (0, 255, 0)
                    
                    cv2.rectangle(frame, (x1, y1), (x2, y2), color, 2)

                if roi_np is not None:
                    frame = draw_roi_on_frame(frame, roi_np.reshape(-1, 2).tolist())

                self.camera_counts[camera_id] = current_count

                camera_info = self.camera_cache.get(camera_id, {})
                zone_name = camera_info.get('zone_name', '')
                area_name = camera_info.get('area_name', '')
                
                crowding_level, percentage = self.calculate_crowding_rate(current_count, capacity)
                
                data = {
                    "zone": zone_name,
                    "area": area_name,
                    "camera_id": camera_id,
                    "capacity": capacity,
                    "number_of_people": current_count,
                    "crowding_level": crowding_level,
                    "crowding_percentage": round(percentage, 2)
                }

                self._add_count(camera_id, current_count, capacity)

                return frame, data
        except Exception as e:
            logger.error(f"Error processing frame for camera {camera_id}: {e}")
            return frame, {}

    def _add_count(self, camera_id, count, capacity):
        try:
            current_minute = self._get_current_minute()
            
            if current_minute != self.current_minute:
                self._calculate_averages_count()
                self.current_minute_data.clear()
                self.current_minute = current_minute
            
            self.current_minute_data[camera_id].append({
                'count': count,
                'capacity': capacity
            })
        except Exception as e:
            logger.error(f"Error adding count for camera {camera_id}: {e}")

    def _calculate_averages_count(self):
        try:
            measurements_to_insert = []
            
            for camera_id, data_points in self.current_minute_data.items():
                if data_points:
                    counts = [d['count'] for d in data_points]
                    average = sum(counts) / len(counts)
                    rounded_average = round(average)
                    capacity = data_points[-1]['capacity']
                    
                    camera_info = self.camera_cache.get(camera_id, {})
                    zone_name = camera_info.get('zone_name', '')
                    area_name = camera_info.get('area_name', '')
                    
                    crowding_level, percentage = self.calculate_crowding_rate(rounded_average, capacity)
                    
                    data = {
                        "zone": zone_name,
                        "area": area_name,
                        "camera_id": camera_id,
                        "capacity": capacity,
                        "number_of_people": rounded_average,
                        "crowding_level": crowding_level,
                        "crowding_percentage": round(percentage, 2)
                    }
                                       
                
                    measurements_to_insert.append(data)

                     # Log the data to a separate file for clarity
                    # data_log_path = os.path.join(log_dir, 'data.log')
                    # with open(data_log_path, 'a') as data_log:
                    #     data_log.write(f"AFTER {datetime.now()} - {data}\n")
            
            if measurements_to_insert:
                self.send_to_database(measurements_to_insert)
        except Exception as e:
            logger.error(f"Error calculating averages: {e}")

    def calculate_crowding_rate(self, number_of_people, capacity):
        try:
            percentage = (number_of_people / capacity) * 100 if capacity > 0 else 0
            
            high_threshold = 0.70
            low_threshold = 0.40

            if number_of_people >= capacity or number_of_people >= high_threshold * capacity:
                return "Crowded", percentage
            elif number_of_people >= low_threshold * capacity:
                return "Moderate", percentage
            else:
                return "Low", percentage
        except Exception as e:
            logger.error(f"Error calculating crowding rate: {e}")
            return "Unknown", 0

    def send_to_database(self, measurements: List[Dict[str, Any]]):
        try:
            crowd_db = CrowdMeasurements()
            success = crowd_db.insert_crowd_data(measurements)
            
            if not success:
                logger.error("Failed to send data to database")
                
        except Exception as e:
            logger.error(f"Error in send_to_database: {e}")