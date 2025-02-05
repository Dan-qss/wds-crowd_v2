import torch
import logging
import base64
import requests
import cv2
from ultralytics import YOLO
import os
import sys
import datetime 
back_dir = os.path.dirname(os.path.dirname(os.path.dirname(__file__)))
sys.path.append(back_dir)
from database.crowd_management_database.face_recognition import FaceRecognitionCRUD
from database.crowd_management_database.face_recognition import UnknownRecognitionCRUD

class Model2:
    def __init__(self):
        self.api_url = 'http://192.168.100.219:3009/Detect_faces'
        self.frame_counter = 0  # Initialize frame counter
            
    def _convert_frame_to_base64(self, frame):
        _, buffer = cv2.imencode('.jpg', frame)
        base64_image = base64.b64encode(buffer).decode('utf-8')
        return f"data:image/jpeg;base64,{base64_image}"
            
    def _send_to_face_api(self, base64_image):
        try:
            headers = {'Content-Type': 'application/json'}
            payload = {'image': base64_image}
            
            response = requests.post(
                self.api_url,
                headers=headers,
                json=payload,
                timeout=30
            )
            
            if response.status_code == 200:
                return response.json()
            else:
                print(f"API error: {response.status_code} - {response.text}")
                return None
                
        except requests.exceptions.RequestException as e:
            print(f"Error calling Face Recognition API: {e}")
            return None
    
    def _send_to_database(self, zone_name, camera_id, person_name, position, status, timestamp):
        """Send face recognition data to the database if the person is not already recorded in the same zone recently."""
        face_crud = FaceRecognitionCRUD()  # Initialize the CRUD class


        # Define a time window (e.g., 20 minutes) to check for duplicates
        time_window = datetime.timedelta(minutes=20)
        start_time = (datetime.datetime.strptime(timestamp, "%Y-%m-%d %H:%M:%S") - time_window).strftime("%Y-%m-%d %H:%M:%S")

        try:
            # Check if the person is already recorded in the same zone within the time window
            existing_records = face_crud.fetch_records(
                zone=zone_name,
                person_name=person_name,
                start_time=start_time,
                end_time=timestamp
            )

            if not existing_records:
                # If no existing records, insert the new record
                face_crud.insert_record(
                    zone=zone_name,
                    camera_id=camera_id,
                    person_name=person_name,
                    position=position,
                    status=status,
                    timestamp=timestamp
                )
                print(f"Data sent to database: {person_name}")
            else:
                print(f"Duplicate detected: {person_name} already recorded in {zone_name} within the last 5 minutes.")
        except Exception as e:
            print(f"Error sending data to database: {e}")

    def _send_unknown_to_database(self, zone_name, camera_id, gender, age, timestamp):
        """Send unknown face recognition data to the database if not already recorded recently."""
        unknown_crud = UnknownRecognitionCRUD()  # Initialize the CRUD class

        # Define a time window (e.g., 20 minutes) to check for duplicates
        time_window = datetime.timedelta(minutes=20)
        start_time = (datetime.datetime.strptime(timestamp, "%Y-%m-%d %H:%M:%S") - time_window).strftime("%Y-%m-%d %H:%M:%S")

        try:
            # Check if a similar person is already recorded in the same zone
            existing_records = unknown_crud.fetch_records_by_zone_gender_age(
                zone_name=zone_name,
                gender=gender,
                age=age,
                start_time=start_time,
                end_time=timestamp
            )

            if not existing_records:
                # If no existing records, insert the new record
                unknown_crud.insert_record(
                    zone_name=zone_name,
                    camera_id=camera_id,
                    timestamp=timestamp,
                    gender=gender,
                    age=age
                )
                print(f"Unknown person data sent to database: Gender={gender}, Age={age}")
            else:
                print(f"Duplicate detected: {gender}, Age {age} in {zone_name} within last 20 minutes")
        except Exception as e:
            print(f"Error sending unknown person data: {e}")
    
    def process(self, frame, camera_id, zone_name):
        # Increment frame counter
        self.frame_counter += 1

        # Skip 5 frames (process every 6th frame)
        if self.frame_counter % 10 != 1:
            return frame

        # Process the frame
        base64_image = self._convert_frame_to_base64(frame)
        if base64_image:
            face_results = self._send_to_face_api(base64_image)
            if face_results:
                for face in face_results:
                    # Get the current timestamp
                    current_time = datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S")
                    
                    if face['name'] != 'unknown':
                        # Prepare the data
                        data = {
                            "zone": zone_name,
                            "camera_id": camera_id,
                            "person_name": face['name'],  
                            "position": face['position'],  
                            "status": face['status'],
                            "timestamp": current_time
                        }  
                        print(data)

                        # Send the data to the database
                        self._send_to_database(
                            zone_name=zone_name,
                            camera_id=camera_id,
                            person_name=face['name'],
                            position=face['position'],
                            status=face['status'],
                            timestamp=current_time
                        )
                    else:
                        data = {
                            "zone": zone_name,
                            "camera_id": camera_id,
                            "gender": face['gender'],
                            "age": face['age'],
                            "timestamp": current_time  
                        }
                        print(data)
                        
                        # Send unknown face data to database
                        self._send_unknown_to_database(
                            zone_name=zone_name,
                            camera_id=camera_id,
                            gender=face['gender'],
                            age=face['age'],
                            timestamp=current_time
                        )
                   
        return frame