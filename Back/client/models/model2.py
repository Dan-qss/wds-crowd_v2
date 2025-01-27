import torch
import logging
import base64
import requests
import cv2
from ultralytics import YOLO

class Model2:
    def __init__(self):
        self.api_url = 'http://192.168.100.65:3009/Detect_faces'
            
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
        
    def process(self, frame, camera_id):
        base64_image = self._convert_frame_to_base64(frame)
        if base64_image:
            face_results = self._send_to_face_api(base64_image)
            if face_results:
                for face in face_results:
                    if face['name'] == 'Unknown':
                        print(f"Camera {camera_id} - Unknown face detected")
                    else:
                        print(f"Camera {camera_id} - Name: {face['name']}")        
        return frame