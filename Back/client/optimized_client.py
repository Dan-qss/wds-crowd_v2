import sys
import os
sys.path.append(os.path.join(os.path.dirname(__file__), "../camera_system"))

import grpc
import camera_service_pb2
import camera_service_pb2_grpc
import cv2
import numpy as np
from queue import Queue
import queue
from threading import Thread
import time
import logging

sys.path.append(os.path.dirname(os.path.dirname(__file__)))
from websocket_server import WebSocketStreamer
from database.camera_system_database.db_connector import DatabaseConnector
from database.camera_system_database.db_config import DB_CONFIG

from models.model1 import Model1
from models.model2 import Model2

# Logs
BACK_DIR = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
log_dir = os.path.join(BACK_DIR, 'logs')
os.makedirs(log_dir, exist_ok=True)

error_log_path = os.path.join(log_dir, 'errors.log')
logging.basicConfig(
    filename=error_log_path,
    level=logging.INFO,
    format='%(asctime)s - %(name)s - %(levelname)s - %(message)s'
)
logger = logging.getLogger(__name__)


GRPC_TARGET = os.environ.get("CAMERA_GRPC_TARGET", "127.0.0.1:50051")


def make_channel():
    # Fresh channel for each camera stream thread (IMPORTANT)
    return grpc.insecure_channel(
        GRPC_TARGET,
        options=[
            ('grpc.max_send_message_length', 100 * 1024 * 1024),
            ('grpc.max_receive_message_length', 100 * 1024 * 1024),
            ('grpc.keepalive_time_ms', 20000),
            ('grpc.keepalive_timeout_ms', 5000),
            ('grpc.keepalive_permit_without_calls', 1),
            ('grpc.http2.max_pings_without_data', 0),
            ('grpc.http2.min_time_between_pings_ms', 10000),
        ],
    )


class OptimizedCameraClient:
    def __init__(self):
        # Cameras per model
        self.MODEL1_CAMERA_IDS = ["1", "2", "3", "4", "5"]
        self.MODEL2_CAMERA_IDS = ["10", "11"]

        # Union (stream + websocket)
        self.camera_ids = self.MODEL1_CAMERA_IDS + self.MODEL2_CAMERA_IDS

        self.running = True
        self.threads = []

        # DB
        self.db = DatabaseConnector(**DB_CONFIG)
        enabled_cameras = self.db.get_enabled_cameras() or []
        self.enabled_cameras_cache = enabled_cameras

        self.camera_capacities = {
            str(cam['camera_id']): cam.get('capacities', 0)
            for cam in enabled_cameras
        }

        # Queues (one per camera)
        self.camera_queues = {cam_id: Queue(maxsize=1) for cam_id in self.camera_ids}

        # Models
        self.model1 = Model1(self.db)
        self.model2 = Model2()


    def _get_camera_info(self, camera_id: str):
        # Avoid querying DB in every loop (but refresh if needed later)
        for cam in self.enabled_cameras_cache:
            if str(cam.get("camera_id")) == str(camera_id):
                return cam
        return None

    def start_camera_stream(self, camera_id: str):
        """
        Stream gRPC frames for a camera.
        Uses a dedicated channel per thread and reconnects on failure.
        """
        while self.running:
            channel = None
            try:
                channel = make_channel()
                stub = camera_service_pb2_grpc.CameraServiceStub(channel)

                request = camera_service_pb2.FrameRequest(camera_id=camera_id)

                # This iterator will raise if the connection drops
                for response in stub.StreamFrames(request):
                    if not self.running:
                        break

                    frame_data = np.frombuffer(response.frame_data, dtype=np.uint8)
                    frame = cv2.imdecode(frame_data, cv2.IMREAD_COLOR)

                    if frame is None:
                        continue

                    # Drop old frame if full
                    if self.camera_queues[camera_id].full():
                        try:
                            self.camera_queues[camera_id].get_nowait()
                        except queue.Empty:
                            pass

                    self.camera_queues[camera_id].put((frame, response.timestamp))

            except grpc.RpcError as e:
                logger.error(f"[{camera_id}] gRPC error: {e}")
                time.sleep(1.0)
            except Exception as e:
                logger.error(f"[{camera_id}] stream thread error: {e}")
                time.sleep(1.0)
            finally:
                try:
                    if channel is not None:
                        channel.close()
                except Exception:
                    pass

    def process_frames(self):
        websocket_streamer = WebSocketStreamer(self.camera_ids)
        websocket_thread = Thread(target=websocket_streamer.run, daemon=True)
        websocket_thread.start()

        while self.running:
            try:
                for camera_id in self.camera_ids:
                    try:
                        frame, timestamp = self.camera_queues[camera_id].get_nowait()
                    except queue.Empty:
                        continue

                    camera_info = self._get_camera_info(camera_id)
                    zone_name = "Unknown"
                    if camera_info:
                        zone_name = camera_info.get("zone_name") or camera_info.get("name") or "Unknown"

                    # Default payload for websocket
                    data = {"name": zone_name}

                    # Route to Model1 only
                    if camera_id in self.MODEL1_CAMERA_IDS:
                        cap = self.camera_capacities.get(camera_id, 0)
                        processed_frame, model1_data = self.model1.process(frame, camera_id, cap)

                        if isinstance(model1_data, dict):
                            model1_data.update({"name": zone_name})
                            data = model1_data

                        websocket_streamer.update_frame(camera_id, processed_frame, data)

                    # Route to Model2 only
                    elif camera_id in self.MODEL2_CAMERA_IDS:
                        processed_frame = self.model2.process(frame, camera_id, zone_name)

                        # Model2 currently doesn't return structured "data" for websocket,
                        # so we just send the frame + zone name
                        websocket_streamer.update_frame(camera_id, processed_frame, data)

                    else:
                        # If any unexpected camera shows up, just forward it raw
                        websocket_streamer.update_frame(camera_id, frame, data)

                time.sleep(0.001)

            except Exception as e:
                logger.error(f"Error in process_frames loop: {e}")
                time.sleep(0.2)

        try:
            websocket_streamer.stop()
        except Exception:
            pass


    def run(self):
        try:
            for camera_id in self.camera_ids:
                t = Thread(target=self.start_camera_stream, args=(camera_id,), daemon=True)
                t.start()
                self.threads.append(t)

            pt = Thread(target=self.process_frames, daemon=True)
            pt.start()
            self.threads.append(pt)

            while self.running:
                time.sleep(0.5)

        except KeyboardInterrupt:
            self.running = False
        except Exception as e:
            logger.error(f"Error in main run loop: {e}")
            self.running = False
        finally:
            self.cleanup()


    def cleanup(self):
        self.running = False
        try:
            cv2.destroyAllWindows()
        except Exception:
            pass


def main():
    client = OptimizedCameraClient()
    client.run()


if __name__ == "__main__":
    main()
