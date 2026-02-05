"""
Interactive ROI setter for a camera stream.

Usage:
  python set_roi_from_stream.py --source 0 --id 1

Controls (on the OpenCV window):
  - Left click: add a point
  - Right click: remove last point (undo)
  - Enter or 's': save the ROI for the specified camera id
  - 'c': clear current points
  - 'q' or ESC: quit without saving

The script will call set_roi(camera_id, roi_points) from `roi.py`, which
will persist the ROI to `camera_rois.json`.

Additionally, it will update the hardcoded `set_roi("<id>", [...])` line in roi.py
so the ROI is reflected in roi.py after saving.
"""

import argparse
import cv2
import numpy as np
import time
import sys
import os
import re

# Ensure we import the local roi module
sys.path.insert(0, os.path.dirname(__file__))
import roi

WINDOW_NAME = "Set ROI - Left click add | Right click undo | Enter save | q quit"

points = []
frame_for_preview = None


def draw_overlay(frame, pts):
    vis = frame.copy()

    # draw existing points
    for p in pts:
        cv2.circle(vis, tuple(p), 4, (0, 0, 255), -1)

    if len(pts) >= 2:
        pts_np = np.array(pts, dtype=np.int32).reshape(-1, 1, 2)
        cv2.polylines(vis, [pts_np], isClosed=False, color=(0, 0, 255), thickness=2)

    if len(pts) >= 3:
        pts_np = np.array(pts, dtype=np.int32)
        overlay = vis.copy()
        cv2.fillPoly(overlay, [pts_np], (0, 0, 255))
        alpha = 0.12
        vis = cv2.addWeighted(overlay, alpha, vis, 1 - alpha, 0)

    # instructions
    cv2.putText(
        vis,
        "L-click add | R-click undo | Enter/s save | c clear | q quit",
        (10, 20),
        cv2.FONT_HERSHEY_SIMPLEX,
        0.5,
        (255, 255, 255),
        1,
        cv2.LINE_AA,
    )
    cv2.putText(
        vis,
        f"Points: {len(pts)}",
        (10, 40),
        cv2.FONT_HERSHEY_SIMPLEX,
        0.6,
        (200, 200, 200),
        1,
        cv2.LINE_AA,
    )

    return vis


def mouse_cb(event, x, y, flags, param):
    global points
    if event == cv2.EVENT_LBUTTONDOWN:
        points.append([int(x), int(y)])
    elif event == cv2.EVENT_RBUTTONDOWN:
        if points:
            points.pop()


def parse_args():
    p = argparse.ArgumentParser(description="Interactive ROI setter for camera streams")
    p.add_argument("--source", "-s", default=0, help="Video source (camera index int or URL). Default 0")
    p.add_argument(
        "--id", "-i", dest="camera_id", default=None,
        help="Camera id to save ROI under (string). If omitted you'll be prompted."
    )
    return p.parse_args()


def normalize_source(src):
    try:
        return int(src)
    except Exception:
        return src


def update_roi_py(camera_id: str, pts: list):
    """
    Update roi.py by replacing/adding the line:
      set_roi("<camera_id>", [[x,y], ...])
    """
    roi_py_path = os.path.join(os.path.dirname(__file__), "roi.py")
    if not os.path.exists(roi_py_path):
        raise FileNotFoundError(f"roi.py not found at: {roi_py_path}")

    with open(roi_py_path, "r", encoding="utf-8") as f:
        content = f.read()

    # Format points in a clean one-liner (matches your current style)
    pts_str = repr(pts)  # e.g. [[1,2],[3,4],...]
    new_line = f'set_roi("{camera_id}", {pts_str})'

    # Replace existing set_roi("<id>", ...) line if present (keeps any trailing comment)
    # This expects the ROI is on ONE LINE (same as your current roi.py).
    pattern = re.compile(
        rf'^(?P<indent>\s*)set_roi\(\s*["\']{re.escape(camera_id)}["\']\s*,\s*.*?\)\s*(?P<comment>#.*)?$',
        re.MULTILINE,
    )

    m = pattern.search(content)
    if m:
        indent = m.group("indent") or ""
        comment = (" " + m.group("comment")) if m.group("comment") else ""
        replacement = f"{indent}{new_line}{comment}"
        content = pattern.sub(replacement, content, count=1)
    else:
        # If not found, insert after the marker comment if it exists, otherwise append.
        marker = "# top-left, top-right, bottom-right, bottom-left"
        insert_line = new_line + "  # updated by set_roi_from_stream.py"

        if marker in content:
            idx = content.index(marker) + len(marker)
            # insert on next line
            content = content[:idx] + "\n" + insert_line + content[idx:]
        else:
            if not content.endswith("\n"):
                content += "\n"
            content += "\n" + insert_line + "\n"

    with open(roi_py_path, "w", encoding="utf-8") as f:
        f.write(content)


def main():
    global points, frame_for_preview
    args = parse_args()

    camera_id = args.camera_id
    if camera_id is None:
        camera_id = input("Enter camera id to assign ROI to: ").strip()
        if camera_id == "":
            print("Camera id cannot be empty. Exiting.")
            return

    source = normalize_source(args.source)

    cap = cv2.VideoCapture(source)
    if not cap.isOpened():
        print(f"Failed to open source: {source}")
        return

    cv2.namedWindow(WINDOW_NAME, cv2.WINDOW_NORMAL)
    cv2.setMouseCallback(WINDOW_NAME, mouse_cb)

    print("Press keys in the window: Left-click add, Right-click undo, Enter or 's' to save, 'c' to clear, 'q' or ESC to quit.")

    last_frame = None

    while True:
        ret, frame = cap.read()
        if not ret:
            time.sleep(0.1)
            continue

        last_frame = frame.copy()
        vis = draw_overlay(frame, points)

        cv2.imshow(WINDOW_NAME, vis)
        key = cv2.waitKey(20) & 0xFF

        if key == ord("q") or key == 27:  # q or ESC
            print("Quitting without saving.")
            break

        if key == ord("c"):
            points = []
            print("Cleared points.")

        if key == ord("s") or key == 13:  # 's' or Enter
            if len(points) < 3:
                print("Need at least 3 points to define a polygon ROI.")
                continue

            print(f"Saving ROI for camera id '{camera_id}' with {len(points)} points...")
            try:
                # 1) Save to JSON via roi module
                roi.set_roi(str(camera_id), points)

                # 2) Update roi.py hardcoded defaults
                update_roi_py(str(camera_id), points)

                print("✅ ROI saved to camera_rois.json AND roi.py updated.")
            except Exception as e:
                print(f"Failed to save ROI: {e}")

            # show the saved ROI briefly
            preview = draw_overlay(last_frame, points)
            cv2.imshow(WINDOW_NAME, preview)
            cv2.waitKey(500)
            break

    cap.release()
    cv2.destroyAllWindows()


if __name__ == "__main__":
    main()
