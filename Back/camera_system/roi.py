# roi.py

import cv2
import numpy as np
import json
import os

# Dictionary to store ROIs for each camera
camera_rois = {}

def save_rois():
  """
  Save the ROIs to a JSON file.
  """
  with open('camera_rois.json', 'w') as f:
      json.dump(camera_rois, f)

def load_rois():
  """
  Load the ROIs from a JSON file.
  """
  global camera_rois
  if os.path.exists('camera_rois.json'):
      with open('camera_rois.json', 'r') as f:
          camera_rois = json.load(f)

def get_roi(camera_id):
  """
  Get the ROI for a specific camera.
  """
  return camera_rois.get(camera_id)

def set_roi(camera_id, roi):
  """
  Set the ROI for a specific camera.
  """
  camera_rois[camera_id] = roi
  save_rois()

def draw_roi_on_frame(frame, roi):
  """
  Draw the ROI polygon on the frame.
  """
  if roi is None or len(roi) < 3:
      return frame
  
  roi_np = np.array(roi, dtype=np.int32).reshape((-1, 1, 2))
  cv2.polylines(frame, [roi_np], True, (0, 0, 255), 2)  # red color (BGR)
  return frame
# Load existing ROIs when the module is imported
load_rois()

# top-left, top-right, bottom-right, bottom-left
set_roi("1", [[160, 100], [350, 100], [585, 360], [70, 385]]) # Set the ROI for software
set_roi("2", [[260, 40], [500, 40], [570, 380], [50, 380]]) # Set the ROI for lab
set_roi("4", [[250, 40], [400, 40], [590, 380], [40, 380]]) # Set the ROI for marketing-&-Sales
set_roi("3", [[220, 20], [440, 20], [620, 380], [20, 380]]) # Set the ROI for showrrom
set_roi("5", [[120, 20], [330, 20], [620, 380], [20, 380]]) # Set the ROI for lab
