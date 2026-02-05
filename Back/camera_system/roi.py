# roi.py
import cv2
import numpy as np
import json
import os
import logging

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

# Rest of the ROI code...
camera_rois = {}

def save_rois():
    try:
        with open('camera_rois.json', 'w') as f:
            json.dump(camera_rois, f)
    except Exception as e:
        logger.error(f"Failed to save ROIs: {e}")

def load_rois():
    """
    Load the ROIs from a JSON file.
    """
    global camera_rois
    try:
        if os.path.exists('camera_rois.json'):
            with open('camera_rois.json', 'r') as f:
                camera_rois = json.load(f)
    except Exception as e:
        logger.error(f"Failed to load ROIs: {e}")

def get_roi(camera_id):
    """
    Get the ROI for a specific camera.
    """
    try:
        return camera_rois.get(camera_id)
    except Exception as e:
        logger.error(f"Error getting ROI for camera {camera_id}: {e}")
        return None

def set_roi(camera_id, roi):
    """
    Set the ROI for a specific camera.
    """
    try:
        camera_rois[camera_id] = roi
        save_rois()
    except Exception as e:
        logger.error(f"Error setting ROI for camera {camera_id}: {e}")

def draw_roi_on_frame(frame, roi):
    """
    Draw the ROI polygon on the frame.
    """
    try:
        if roi is None or len(roi) < 3:
            return frame
        
        roi_np = np.array(roi, dtype=np.int32).reshape((-1, 1, 2))
        cv2.polylines(frame, [roi_np], True, (0, 0, 255), 2)  # red color (BGR)
        return frame
    except Exception as e:
        logger.error(f"Error drawing ROI on frame: {e}")
        return frame

# Load existing ROIs when the module is imported
load_rois()

# top-left, top-right, bottom-right, bottom-left
set_roi("1", [[57, 1814], [2534, 518], [3283, 1286], [2275, 2112], [76, 2112]]) # Set the ROI for software
set_roi("2", [[412, 2140], [1132, 796], [1612, 38], [2208, 0], [3350, 902], [3792, 2102]]) # Set the ROI for lab 1 
set_roi("3", [[19, 2112], [307, 1171], [1286, 48], [1737, 48], [2630, 998], [3292, 1574], [3427, 2112]]) # Set the ROI for lab 2
set_roi("4", [[38, 2083], [96, 1401], [316, 835], [3734, 969], [3801, 2140]]) # Set the ROI for showroom
set_roi("5", [[3158, 2131], [1574, 0], [1027, 0], [105, 585], [345, 1632], [1123, 2140]]) # Set the ROI for marketing-&-Sales