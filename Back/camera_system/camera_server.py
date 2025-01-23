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
        frames_sent = 0
        
        while context.is_active():
            try:
                frame = self.camera_manager.get_frame(request.camera_id)
                if frame is not None:
                    _, buffer = cv2.imencode('.jpg', frame, [cv2.IMWRITE_JPEG_QUALITY, 95])
                    height, width = frame.shape[:2]
                    frames_sent += 1
                    
                    # Print resolution information
                    # print(f"Server streaming frame {frames_sent} from camera {request.camera_id}")
                    # print(f"Frame resolution: {width}x{height}")
                    # print(f"Compressed buffer size: {len(buffer)} bytes")
                    
                    yield camera_service_pb2.FrameResponse(
                        frame_data=buffer.tobytes(),
                        width=width,
                        height=height,
                        timestamp=datetime.now().isoformat()
                    )
                    
                time.sleep(1/30)
            except Exception as e:
                logger.error(f"Error streaming camera {request.camera_id}: {e}")
                break

    def GetCameraStatus(self, request, context):
        try:
            status = self.camera_manager.get_camera_status(request.camera_id)
            return camera_service_pb2.StatusResponse(**status)
        except Exception as e:
            logger.error(f"Error getting status for camera {request.camera_id}: {e}")
            context.set_code(grpc.StatusCode.INTERNAL)
            return camera_service_pb2.StatusResponse()

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
        server.wait_for_termination()
    except Exception as e:
        logger.error(f"Critical server error: {e}")
        raise

if __name__ == '__main__':
    try:
        serve()
    except KeyboardInterrupt:
        pass
    except Exception as e:
        logger.error(f"Fatal server error: {e}")