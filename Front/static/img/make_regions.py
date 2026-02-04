import cv2
import numpy as np
import json
import os

IMAGE_PATH = r"D:\wds-crowd_v2\Front\static\img\map.png"
OUT_JSON   = r"D:\wds-crowd_v2\Front\static\img\regions.json"
OUT_NPZ    = r"D:\wds-crowd_v2\Front\static\img\masks.npz"
OUT_MASK_DIR = r"D:\wds-crowd_v2\Front\static\img\masks"
NUM_ZONES = 5

# عرض النافذة (فقط للعرض)
PREVIEW_MAX_W = 1200
PREVIEW_MAX_H = 700

points_current = []   # نقاط بالحجم الأصلي (x,y)
zones = []
masks = {}

win = "Draw zones | LeftClick add | Enter finish | u undo | r reset | Esc quit"

from PIL import Image
import numpy as np
import cv2

def read_image_safe(path):
    # RGB ثم إلى BGR عشان OpenCV
    im = Image.open(path).convert("RGB")
    return cv2.cvtColor(np.array(im), cv2.COLOR_RGB2BGR)

img = read_image_safe(IMAGE_PATH)
if img is None:
  raise FileNotFoundError(f"Could not read image: {IMAGE_PATH}")

H, W = img.shape[:2]

# حساب سكيل للـpreview
scale = min(PREVIEW_MAX_W / W, PREVIEW_MAX_H / H, 1.0)
previewW, previewH = int(W * scale), int(H * scale)

def to_preview(pt):
  x, y = pt
  return (int(x * scale), int(y * scale))

def to_original(xp, yp):
  # يرجّع coords أصلية من coords المعروضة
  x = int(xp / scale)
  y = int(yp / scale)
  # clamp
  x = max(0, min(W - 1, x))
  y = max(0, min(H - 1, y))
  return x, y

def draw_preview():
  # نصغّر للصورة للعرض
  vis = cv2.resize(img, (previewW, previewH), interpolation=cv2.INTER_AREA)

  # draw saved zones
  for z in zones:
    pts = np.array([to_preview((p["x"], p["y"])) for p in z["points"]], dtype=np.int32)
    cv2.polylines(vis, [pts], True, (0,0,0), 2)
    overlay = vis.copy()
    cv2.fillPoly(overlay, [pts], (0,255,0))
    vis = cv2.addWeighted(overlay, 0.25, vis, 0.75, 0)

    cx, cy = int(pts[:,0].mean()), int(pts[:,1].mean())
    cv2.putText(vis, f"Zone {z['id']}", (cx, cy),
                cv2.FONT_HERSHEY_SIMPLEX, 0.8, (20,20,20), 2, cv2.LINE_AA)

  # current points
  if points_current:
    for p in points_current:
      cv2.circle(vis, to_preview(p), 4, (255,0,0), -1)
    if len(points_current) >= 2:
      pts = np.array([to_preview(p) for p in points_current], dtype=np.int32).reshape(-1,1,2)
      cv2.polylines(vis, [pts], False, (255,0,0), 2)

  cv2.putText(vis, f"Ready: Zone {len(zones)+1}/{NUM_ZONES}",
              (20, 30), cv2.FONT_HERSHEY_SIMPLEX, 0.9, (20,20,20), 2, cv2.LINE_AA)

  return vis

def make_mask_from_points(pts_list):
  mask = np.zeros((H, W), dtype=np.uint8)
  pts = np.array(pts_list, dtype=np.int32)
  cv2.fillPoly(mask, [pts], 255)
  return mask

def on_mouse(event, x, y, flags, param):
  global points_current
  if event == cv2.EVENT_LBUTTONDOWN:
    ox, oy = to_original(x, y)   # تحويل من preview -> original
    points_current.append((ox, oy))

cv2.namedWindow(win, cv2.WINDOW_NORMAL)
cv2.resizeWindow(win, previewW, previewH)
cv2.setMouseCallback(win, on_mouse)

while True:
  vis = draw_preview()
  cv2.imshow(win, vis)
  key = cv2.waitKey(20) & 0xFF

  if key == 27:  # ESC
    break

  if key == ord('u'):
    if points_current:
      points_current.pop()

  if key == ord('r'):
    points_current = []

  if key == 13:  # Enter
    if len(zones) >= NUM_ZONES:
      print("Already have 5 zones.")
      continue
    if len(points_current) < 3:
      print("Need at least 3 points.")
      continue

    zone_id = len(zones) + 1
    zone_points = [{"x": int(x), "y": int(y)} for (x,y) in points_current]
    zones.append({"id": zone_id, "points": zone_points})

    mask = make_mask_from_points(points_current)
    masks[str(zone_id)] = mask
    print(f"Saved Zone {zone_id} | points={len(points_current)} | mask_pixels={(mask>0).sum()}")

    points_current = []

cv2.destroyAllWindows()

if not zones:
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

np.savez_compressed(OUT_NPZ, **{f"zone_{k}": v for k, v in masks.items()})

for k, m in masks.items():
  cv2.imwrite(os.path.join(OUT_MASK_DIR, f"mask_zone{k}.png"), m)

print(f"Saved:\n- {OUT_JSON}\n- {OUT_NPZ}\n- {OUT_MASK_DIR}\\mask_zone*.png")
