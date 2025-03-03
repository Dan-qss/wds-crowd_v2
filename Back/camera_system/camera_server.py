import grpc
from concurrent import futures
import camera_service_pb2
import camera_service_pb2_grpc
from camera_manager import CameraManager
import cv2
import numpy as np
from datetime import datetime
import time
import logging
import signal
import os

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

class CameraServicer(camera_service_pb2_grpc.CameraServiceServicer):
    def __init__(self):
        try:
            self.camera_manager = CameraManager()
            self.camera_manager.start_all_cameras()
        except Exception as e:
            logger.error(f"Failed to initialize CameraServicer: {e}")
            raise

    def StreamFrames(self, request, context):
        camera_id = request.camera_id
        frames_sent = 0
        consecutive_failures = 0
        max_failures = 5
        
        # First check if the camera exists and is running
        status = self.camera_manager.get_camera_status(camera_id)
        if not status.get('running', False):
            try:
                # Try to start the camera if it's not running
                self.camera_manager.start_camera(camera_id)
                logger.info(f"Started camera {camera_id} for streaming")
            except Exception as e:
                logger.error(f"Failed to start camera {camera_id}: {e}")
                context.set_details(f"Camera {camera_id} is not available")
                context.set_code(grpc.StatusCode.UNAVAILABLE)
                return
        
        while context.is_active():
            try:
                # Get a frame with timeout handling
                frame = None
                retry_count = 0
                while frame is None and retry_count < 3 and context.is_active():
                    frame = self.camera_manager.get_frame(camera_id)
                    if frame is None:
                        retry_count += 1
                        time.sleep(0.1)  # Short delay before retry
                
                if frame is not None:
                    _, buffer = cv2.imencode('.jpg', frame, [cv2.IMWRITE_JPEG_QUALITY, 95])
                    height, width = frame.shape[:2]
                    frames_sent += 1
                    consecutive_failures = 0  # Reset failure counter on success
                    
                    yield camera_service_pb2.FrameResponse(
                        frame_data=buffer.tobytes(),
                        width=width,
                        height=height,
                        timestamp=datetime.now().isoformat()
                    )
                else:
                    consecutive_failures += 1
                    if consecutive_failures > max_failures:
                        logger.error(f"Too many consecutive failures for camera {camera_id}, stopping stream")
                        break
                        
                time.sleep(1/30)  # 30 FPS limit
                
            except Exception as e:
                logger.error(f"Error streaming camera {camera_id}: {e}")
                consecutive_failures += 1
                if consecutive_failures > max_failures:
                    logger.error(f"Too many consecutive errors for camera {camera_id}, stopping stream")
                    break
                time.sleep(0.5)  # Longer delay after an error

    def GetCameraStatus(self, request, context):
        try:
            status = self.camera_manager.get_camera_status(request.camera_id)
            return camera_service_pb2.StatusResponse(**status)
        except Exception as e:
            logger.error(f"Error getting status for camera {request.camera_id}: {e}")
            context.set_code(grpc.StatusCode.INTERNAL)
            context.set_details(f"Error getting camera status: {str(e)}")
            return camera_service_pb2.StatusResponse(
                running=False,
                connected=False,
                queue_size=0,
                name=f"Camera {request.camera_id}"
            )

def serve():
    try:
        server = grpc.server(
            futures.ThreadPoolExecutor(max_workers=20),
            options=[
                ('grpc.max_send_message_length', 100 * 1024 * 1024),
                ('grpc.max_receive_message_length', 100 * 1024 * 1024),
                ('grpc.keepalive_time_ms', 10000),
                ('grpc.keepalive_timeout_ms', 5000),
                ('grpc.http2.min_time_between_pings_ms', 10000),
                ('grpc.http2.max_pings_without_data', 0)
            ]
        )
        camera_service_pb2_grpc.add_CameraServiceServicer_to_server(CameraServicer(), server)
    
        server.add_insecure_port('[::]:50051')
        server.start()
        
        print("Camera server started on port 50051")
        
        def handle_shutdown(signum, frame):
            print("Shutting down camera server...")
            server.stop(0)
            
        signal.signal(signal.SIGINT, handle_shutdown)
        signal.signal(signal.SIGTERM, handle_shutdown)
        
        server.wait_for_termination()
    except Exception as e:
        logger.error(f"Critical server error: {e}")
        raise

if __name__ == '__main__':
    try:
        serve()
    except KeyboardInterrupt:
        print("Server stopped by keyboard interrupt")
    except Exception as e:
        logger.error(f"Fatal server error: {e}")
        print(f"Fatal error: {e}")