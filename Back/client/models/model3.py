import torch
import cv2
import logging
from ultralytics import YOLO
from pathlib import Path

logger = logging.getLogger(__name__)

class Model3:
    """Third YOLO model focusing on specific classes and saving images"""
    def __init__(self):
        self.save_dir = Path("results/model3")
        self.save_dir.mkdir(parents=True, exist_ok=True)
        
        self.model = YOLO('yolov8n.pt')
        if torch.cuda.is_available():
            self.model = self.model.to('cuda')
            torch.backends.cudnn.benchmark = True
            torch.backends.cudnn.deterministic = False
            torch.backends.cuda.matmul.allow_tf32 = True
            torch.backends.cudnn.allow_tf32 = True
        logger.info("Model 3 (YOLO) loaded")
        
    def process(self, frame, camera_id, timestamp):
        with torch.inference_mode():
            results = self.model(frame, conf=0.35, verbose=False, classes=[0, 67])
            if len(results[0].boxes) > 0:
                processed_frame = results[0].plot()
                save_path = self.save_dir / f"cam_{camera_id}_{timestamp}.jpg"
                cv2.imwrite(str(save_path), processed_frame)
            
        return frame
