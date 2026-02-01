import grpc
from concurrent import futures
import camera_service_pb2
import camera_service_pb2_grpc
from camera_manager import CameraManager

import cv2
from datetime import datetime
import time
import logging
import signal
import os
from threading import Thread, Event

# Logs
BACK_DIR = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
log_dir = os.path.join(BACK_DIR, 'logs')
os.makedirs(log_dir, exist_ok=True)

error_log_path = os.path.join(log_dir, 'errors.log')
logging.basicConfig(
    filename=error_log_path,
    level=logging.INFO,   # <-- INFO so you can see startup / boot messages
    format='%(asctime)s - %(name)s - %(levelname)s - %(message)s'
)
logger = logging.getLogger(__name__)


class CameraServicer(camera_service_pb2_grpc.CameraServiceServicer):
    """
    IMPORTANT:
    - Do NOT block gRPC server startup in __init__.
    - Boot CameraManager in a background thread.
    """
    def __init__(self):
        self.camera_manager = None
        self.ready_event = Event()
        self.boot_error = None

        Thread(target=self._boot_camera_manager, daemon=True).start()

    def _boot_camera_manager(self):
        try:
            logger.info("[BOOT] Initializing CameraManager...")
            print("[BOOT] Initializing CameraManager...")

            self.camera_manager = CameraManager()
            self.camera_manager.start_all_cameras()

            self.ready_event.set()
            logger.info("[BOOT] CameraManager ready")
            print("[BOOT] CameraManager ready")
        except Exception as e:
            self.boot_error = str(e)
            self.camera_manager = None
            logger.error(f"[BOOT] CameraManager boot failed: {e}")
            print(f"[BOOT] CameraManager boot failed: {e}")

    def StreamFrames(self, request, context):
        camera_id = request.camera_id

        # Fail fast if not ready (prevents handshake stalls)
        if not self.ready_event.is_set() or self.camera_manager is None:
            context.set_code(grpc.StatusCode.UNAVAILABLE)
            context.set_details(f"Camera system not ready: {self.boot_error or 'initializing'}")
            return

        # Ensure camera is running
        status = self.camera_manager.get_camera_status(camera_id)
        if not status.get("running", False):
            try:
                self.camera_manager.start_camera(camera_id)
            except Exception as e:
                logger.error(f"Failed to start camera {camera_id}: {e}")
                context.set_code(grpc.StatusCode.UNAVAILABLE)
                context.set_details(f"Camera {camera_id} is not available")
                return

        consecutive_failures = 0
        max_failures = 30   # allow a bit more tolerance
        last_reconnect_attempt = 0
        reconnect_interval = 10  # seconds

        while context.is_active():
            try:
                now = time.time()

                # If we're failing too much, force reconnect periodically
                if consecutive_failures >= 10 and (now - last_reconnect_attempt) > reconnect_interval:
                    last_reconnect_attempt = now
                    try:
                        logger.warning(f"[{camera_id}] forcing reconnect after failures")
                        self.camera_manager.force_reconnect_camera(camera_id)
                    except Exception as e:
                        logger.error(f"[{camera_id}] force reconnect failed: {e}")
                    consecutive_failures = 0
                    time.sleep(1)

                # Get frame
                frame = self.camera_manager.get_frame(camera_id)

                if frame is None:
                    consecutive_failures += 1
                    if consecutive_failures >= max_failures:
                        # Don't kill the stream; just slow down (client can keep connection)
                        time.sleep(0.5)
                    else:
                        time.sleep(0.05)
                    continue

                consecutive_failures = 0

                ok, buffer = cv2.imencode(".jpg", frame, [cv2.IMWRITE_JPEG_QUALITY, 85])
                if not ok:
                    continue

                h, w = frame.shape[:2]

                yield camera_service_pb2.FrameResponse(
                    frame_data=buffer.tobytes(),
                    width=w,
                    height=h,
                    timestamp=datetime.now().isoformat()
                )

                time.sleep(1 / 30)

            except Exception as e:
                logger.error(f"Error streaming camera {camera_id}: {e}")
                consecutive_failures += 1
                time.sleep(0.2)

    def GetCameraStatus(self, request, context):
        if not self.ready_event.is_set() or self.camera_manager is None:
            return camera_service_pb2.StatusResponse(
                running=False,
                connected=False,
                queue_size=0,
                name=f"Camera {request.camera_id}"
            )
        try:
            status = self.camera_manager.get_camera_status(request.camera_id)
            return camera_service_pb2.StatusResponse(**status)
        except Exception as e:
            logger.error(f"Error getting status for camera {request.camera_id}: {e}")
            context.set_code(grpc.StatusCode.INTERNAL)
            context.set_details(str(e))
            return camera_service_pb2.StatusResponse(
                running=False,
                connected=False,
                queue_size=0,
                name=f"Camera {request.camera_id}"
            )

    def ForceReconnect(self, request, context):
        if not self.ready_event.is_set() or self.camera_manager is None:
            return camera_service_pb2.ReconnectResponse(success=False, message="Camera system not ready")
        try:
            ok = self.camera_manager.force_reconnect_camera(request.camera_id)
            return camera_service_pb2.ReconnectResponse(
                success=ok,
                message="Reconnection initiated" if ok else "Failed to initiate reconnection"
            )
        except Exception as e:
            logger.error(f"Error in ForceReconnect({request.camera_id}): {e}")
            context.set_code(grpc.StatusCode.INTERNAL)
            context.set_details(str(e))
            return camera_service_pb2.ReconnectResponse(success=False, message=str(e))


def serve():
    server = grpc.server(
        futures.ThreadPoolExecutor(max_workers=50),
        options=[
            ('grpc.max_send_message_length', 100 * 1024 * 1024),
            ('grpc.max_receive_message_length', 100 * 1024 * 1024),
            ('grpc.keepalive_time_ms', 10000),
            ('grpc.keepalive_timeout_ms', 5000),
            ('grpc.http2.min_time_between_pings_ms', 10000),
            ('grpc.http2.max_pings_without_data', 0),
        ]
    )

    servicer = CameraServicer()
    camera_service_pb2_grpc.add_CameraServiceServicer_to_server(servicer, server)

    # Bind explicitly to localhost (your client uses 127.0.0.1)
    server.add_insecure_port('127.0.0.1:50051')
    server.start()

    print("Camera server started on port 50051")
    logger.info("Camera server started on port 50051")

    def handle_shutdown(signum, frame):
        print("Shutting down camera server...")
        logger.info("Shutting down camera server...")
        server.stop(0)

    signal.signal(signal.SIGINT, handle_shutdown)
    signal.signal(signal.SIGTERM, handle_shutdown)

    server.wait_for_termination()


if __name__ == '__main__':
    serve()
