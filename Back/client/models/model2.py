import torch
import logging
from ultralytics import YOLO
from pathlib import Path
import json

logger = logging.getLogger(__name__)

class Model2:
    """Second YOLO model with different classes and saving detections"""
    def __init__(self):
        self.save_dir = Path("results/model2")
        self.save_dir.mkdir(parents=True, exist_ok=True)
        
        self.model = YOLO('yolov8n.pt')
        if torch.cuda.is_available():
            self.model = self.model.to('cuda')
            torch.backends.cudnn.benchmark = True
            torch.backends.cudnn.deterministic = False
            torch.backends.cuda.matmul.allow_tf32 = True
            torch.backends.cudnn.allow_tf32 = True
        logger.info("Model 2 (YOLO) loaded")
        
    def process(self, frame, camera_id, timestamp):
        with torch.inference_mode():
            results = self.model(frame, conf=0.40, verbose=False)
            
            # Only process and save if detections found
            if len(results[0].boxes) > 0:
                detections = []
                for r in results[0].boxes:
                    box = r.xyxy[0].cpu().numpy()
                    conf = float(r.conf[0])
                    cls = int(r.cls[0])
                    
                    detections.append({
                        "class": cls,
                        "confidence": conf,
                        "bbox": box.tolist()
                    })
                
                save_path = self.save_dir / f"cam_{camera_id}_{timestamp}"
                with open(f"{save_path}.json", 'w') as f:
                    json.dump(detections, f, indent=2)
                    
                logger.debug(f"Model 2: Found {len(detections)} detections for camera {camera_id}")
            
        return frame
