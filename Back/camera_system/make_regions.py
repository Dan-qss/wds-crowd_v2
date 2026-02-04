import cv2
import numpy as np
import json
import os

# ====== CONFIG ======
IMAGE_PATH = r"D:\wds-crowd_v2\Front\static\img\map.png"
OUT_JSON   = r"D:\wds-crowd_v2\Front\static\img\regions.json"
OUT_NPZ    = r"D:\wds-crowd_v2\Front\static\img\masks.npz"
OUT_MASK_DIR = r"D:\wds-crowd_v2\Front\static\img\masks"  # optional PNG masks
NUM_ZONES = 5
# ====================

points_current = []
zones = []         # list of dicts: {id:int, points:[{x,y},...]}
masks = {}         # dict: zone_id -> uint8 mask

win = "Draw zones: LeftClick add | Enter finish zone | u undo | r reset zone | Esc quit"
img = cv2.imread(IMAGE_PATH)
if img is None:
  raise FileNotFoundError(f"Could not read image: {IMAGE_PATH}")

H, W = img.shape[:2]

def draw_preview(base):
  """Draw polygons + current points on a copy and return it."""
  vis = base.copy()

  # draw saved zones
  for z in zones:
    pts = np.array([[p["x"], p["y"]] for p in z["points"]], dtype=np.int32)
    cv2.polylines(vis, [pts], isClosed=True, color=(0, 0, 0), thickness=2)
    # fill with transparent-ish effect (manual)
    overlay = vis.copy()
    cv2.fillPoly(overlay, [pts], color=(0, 255, 0))
    alpha = 0.25
    vis = cv2.addWeighted(overlay, alpha, vis, 1 - alpha, 0)

    # label
    cx, cy = int(pts[:,0].mean()), int(pts[:,1].mean())
    cv2.putText(vis, f"Zone {z['id']}", (cx, cy),
                cv2.FONT_HERSHEY_SIMPLEX, 0.8, (10,10,10), 2, cv2.LINE_AA)

  # draw current polyline
  if len(points_current) > 0:
    for p in points_current:
      cv2.circle(vis, (p[0], p[1]), 4, (255, 0, 0), -1)  # blue point
    if len(points_current) >= 2:
      pts = np.array(points_current, dtype=np.int32).reshape(-1,1,2)
      cv2.polylines(vis, [pts], isClosed=False, color=(255, 0, 0), thickness=2)

    cv2.putText(vis, f"Drawing Zone {len(zones)+1}/{NUM_ZONES} : {len(points_current)} pts",
                (20, 30), cv2.FONT_HERSHEY_SIMPLEX, 0.8, (20,20,20), 2, cv2.LINE_AA)

  else:
    cv2.putText(vis, f"Ready: Zone {len(zones)+1}/{NUM_ZONES}",
                (20, 30), cv2.FONT_HERSHEY_SIMPLEX, 0.8, (20,20,20), 2, cv2.LINE_AA)

  return vis

def make_mask_from_points(pts_list):
  """pts_list: list[(x,y)]"""
  mask = np.zeros((H, W), dtype=np.uint8)
  pts = np.array(pts_list, dtype=np.int32)
  cv2.fillPoly(mask, [pts], 255)
  return mask

def on_mouse(event, x, y, flags, param):
  global points_current
  if event == cv2.EVENT_LBUTTONDOWN:
    points_current.append((x, y))

cv2.namedWindow(win, cv2.WINDOW_NORMAL)
cv2.setMouseCallback(win, on_mouse)

while True:
  vis = draw_preview(img)
  cv2.imshow(win, vis)
  key = cv2.waitKey(20) & 0xFF

  if key == 27:  # ESC
    print("Exit without saving (unless already saved).")
    break

  if key == ord('u'):  # undo last point
    if points_current:
      points_current.pop()

  if key == ord('r'):  # reset current zone
    points_current = []

  if key == 13:  # Enter finishes a zone
    if len(zones) >= NUM_ZONES:
      print("Already have 5 zones.")
      continue

    if len(points_current) < 3:
      print("Need at least 3 points to close a polygon.")
      continue

    zone_id = len(zones) + 1
    zone_points = [{"x": int(x), "y": int(y)} for (x, y) in points_current]
    zones.append({"id": zone_id, "points": zone_points})

    mask = make_mask_from_points(points_current)
    masks[str(zone_id)] = mask

    print(f"Saved Zone {zone_id} with {len(points_current)} points. Mask pixels={(mask>0).sum()}")

    points_current = []

    if len(zones) == NUM_ZONES:
      print("✅ Completed 5 zones. Press ESC to close and save automatically.")
      # We can auto-save here if you prefer
      # break

# ----- SAVE if any zones -----
cv2.destroyAllWindows()

if len(zones) == 0:
  raise SystemExit("No zones drawn. Nothing saved.")

os.makedirs(os.path.dirname(OUT_JSON), exist_ok=True)
os.makedirs(os.path.dirname(OUT_NPZ), exist_ok=True)
os.makedirs(OUT_MASK_DIR, exist_ok=True)

payload = {
  "image": os.path.basename(IMAGE_PATH),
  "width": W,
  "height": H,
  "zones": zones
}

with open(OUT_JSON, "w", encoding="utf-8") as f:
  json.dump(payload, f, ensure_ascii=False, indent=2)

# Save masks as npz
np.savez_compressed(OUT_NPZ, **{f"zone_{k}": v for k, v in masks.items()})

# Optional: save each mask as PNG
for k, m in masks.items():
  cv2.imwrite(os.path.join(OUT_MASK_DIR, f"mask_zone{k}.png"), m)

print(f"\nSaved:\n- {OUT_JSON}\n- {OUT_NPZ}\n- {OUT_MASK_DIR}\\mask_zone*.png")
`
