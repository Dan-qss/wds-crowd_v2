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

logger = logging.getLogger(__name__)

class Model1:
    def __init__(self, db_connector):
        self.model = YOLO('yolov8n.pt')
        self.db = db_connector
        
        # Cache camera and room data
        self._init_cache()
        
        # GPU optimizations
        if torch.cuda.is_available():
            self.model = self.model.to('cuda')
            torch.backends.cudnn.benchmark = True
            torch.backends.cudnn.deterministic = False
            torch.cuda.set_device(0)  # Ensure using first GPU
            
        logger.info("Model 1 (YOLO) loaded with database integration")

    def _init_cache(self):
        """Initialize cache with zone and area information"""
        enabled_cameras = self.db.get_enabled_cameras()
        
        # Cache camera data with zone and area information
        self.camera_cache = {
            str(cam['camera_id']): {
                'zone_name': cam['name'],
                'area_name': cam['area_name'],
                'capacity': cam['capacities']
            } for cam in enabled_cameras
        }
        
        self.camera_counts = {str(cam['camera_id']): 0 for cam in enabled_cameras}
        
        # Cache ROI data
        self.roi_cache = {}
        for camera_id in self.camera_counts.keys():
            roi = get_roi(camera_id)
            if roi and len(roi) > 2:
                self.roi_cache[camera_id] = np.array(roi, dtype=np.int32).reshape((-1, 1, 2))
            else:
                self.roi_cache[camera_id] = None
        
        # Time tracking
        self.current_minute_data = defaultdict(list)
        self.current_minute = self._get_current_minute()

    def _build_room_config(self, enabled_cameras):
        """Build room configuration cache"""
        room_config = defaultdict(lambda: {'cameras': [], 'total_capacity': 0})
        
        for camera in enabled_cameras:
            room_name = camera['name']
            camera_id = str(camera['camera_id'])
            room_config[room_name]['cameras'].append(camera_id)
            room_config[room_name]['total_capacity'] += camera['capacities']
        
        return dict(room_config)

    def get_room_data(self, camera_id):
        """Get room data from cache"""
        camera = self.camera_cache.get(camera_id)
        if camera:
            room_name = camera['name']
            return room_name, self.room_config.get(room_name)
        return None, None

    def process(self, frame, camera_id, capacity):
        """Process a frame with cached data"""
        with torch.inference_mode():
            # Use cached ROI
            roi_np = self.roi_cache.get(camera_id)
            
            # Run YOLO detection
            results = self.model(frame, conf=0.20, verbose=False, classes=[0], device=0)
            
            # Count people and draw boxes
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

            # Update camera count
            self.camera_counts[camera_id] = current_count

            # Get camera info from cache
            camera_info = self.camera_cache.get(camera_id, {})
            zone_name = camera_info.get('zone_name', '')
            area_name = camera_info.get('area_name', '')
            
            # Calculate crowding metrics
            crowding_level, percentage = self.calculate_crowding_rate(current_count, capacity)
            
            # Format data according to new structure
            data = {
                "zone": zone_name,
                "area": area_name,
                "camera_id": camera_id,
                "capacity": capacity,
                "number_of_people": current_count,
                "crowding_level": crowding_level,
                "crowding_percentage": round(percentage, 2)
            }

            # Add count data for minute summary
            self._add_count(camera_id, current_count, capacity)

            return frame, data
    
    def _get_current_minute(self):
        """Get current time rounded to minute"""
        return datetime.now().strftime('%Y-%m-%d %H:%M')
    
    def _add_count(self, camera_id, count, capacity):
        """Add a new count for the current minute"""
        current_minute = self._get_current_minute()
        
        # Check if minute has changed
        if current_minute != self.current_minute:
            self._calculate_averages_count()
            self.current_minute_data.clear()
            self.current_minute = current_minute
        
        # Add new count data
        self.current_minute_data[camera_id].append({
            'count': count,
            'capacity': capacity
        })


    
    def _calculate_averages_count(self):
        """Calculate and print averages for the previous minute"""
        print(f"\n=== Summary for {self.current_minute} ===")
        
        measurements_to_insert = []
        
        # Process individual cameras
        for camera_id, data_points in self.current_minute_data.items():
            if data_points:
                # Calculate statistics
                counts = [d['count'] for d in data_points]
                average = sum(counts) / len(counts)
                rounded_average = round(average)
                capacity = data_points[-1]['capacity']
                
                # Get camera info
                camera_info = self.camera_cache.get(camera_id, {})
                zone_name = camera_info.get('zone_name', '')
                area_name = camera_info.get('area_name', '')
                
                # Calculate crowding metrics
                crowding_level, percentage = self.calculate_crowding_rate(rounded_average, capacity)
                
                # Print formatted summary
                print(f"\nCamera {camera_id} ({zone_name} - {area_name})")
                print(f"Time: {self.current_minute}")
                print(f"All counts: {counts}")
                print(f"Average count: {rounded_average:.2f}")
                print(f"Capacity: {capacity}")
                print(f"Crowding Level: {crowding_level}")
                print(f"Crowding Percentage: {percentage:.2f}%")
                
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
        
        # Send data to database
        if measurements_to_insert:
            self.send_to_database(measurements_to_insert)
            

    def calculate_crowding_rate(self, number_of_people, capacity):
        """Calculate crowding level and percentage"""
        percentage = (number_of_people / capacity) * 100 if capacity > 0 else 0
        
        # Define thresholds
        high_threshold = 0.70
        low_threshold = 0.40

        # Determine crowding level
        if number_of_people >= capacity or number_of_people >= high_threshold * capacity:
            return "Crowded", percentage
        elif number_of_people >= low_threshold * capacity:
            return "Moderate", percentage
        else:
            return "Low", percentage
        
    def send_to_database(self, measurements: List[Dict[str, Any]]):
        """Send crowd measurements to database"""
        try:
            crowd_db = CrowdMeasurements()
            success = crowd_db.insert_crowd_data(measurements)
            
            if success:
                logger.info("Successfully sent data to database")
            else:
                logger.error("Failed to send data to database")
                
        except Exception as e:
            logger.error(f"Error in send_to_database: {str(e)}")
            
    