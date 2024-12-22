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

# Create logs directory if it doesn't exist
os.makedirs('logs', exist_ok=True)

# Configure logging to both file and console
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(name)s - %(levelname)s - %(message)s',
    handlers=[
        logging.FileHandler('logs/camera_server.log'),
        logging.StreamHandler()  # Keep console output as well
    ]
)
logger = logging.getLogger(__name__)

class CameraServicer(camera_service_pb2_grpc.CameraServiceServicer):
    def __init__(self):
        logger.info("Initializing CameraServicer...")
        self.camera_manager = CameraManager()
        logger.info("Starting all cameras...")
        self.camera_manager.start_all_cameras()
        logger.info("All cameras started")

    def StreamFrames(self, request, context):
        logger.info(f"New stream request for camera {request.camera_id}")
        frames_sent = 0
        
        while context.is_active():
            try:
                frame = self.camera_manager.get_frame(request.camera_id)
                if frame is not None:
                    _, buffer = cv2.imencode('.jpg', frame, [cv2.IMWRITE_JPEG_QUALITY, 80])
                    height, width = frame.shape[:2]
                    frames_sent += 1
                    if frames_sent % 30 == 0:  # Log every 30 frames
                        logger.info(f"Camera {request.camera_id}: sent {frames_sent} frames")
                    
                    yield camera_service_pb2.FrameResponse(
                        frame_data=buffer.tobytes(),
                        width=width,
                        height=height,
                        timestamp=datetime.now().isoformat()
                    )
                else:
                    logger.warning(f"No frame available for camera {request.camera_id}")
                time.sleep(1/30)
            except Exception as e:
                logger.error(f"Error streaming camera {request.camera_id}: {e}")
                break
        
        logger.info(f"Stream ended for camera {request.camera_id}. Total frames sent: {frames_sent}")

    def GetCameraStatus(self, request, context):
        try:
            status = self.camera_manager.get_camera_status(request.camera_id)
            logger.info(f"Status request for camera {request.camera_id}: {status}")
            return camera_service_pb2.StatusResponse(**status)
        except Exception as e:
            logger.error(f"Error getting status for camera {request.camera_id}: {e}")
            context.set_code(grpc.StatusCode.INTERNAL)
            return camera_service_pb2.StatusResponse()

def serve():
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
    logger.info("Server started on port 50051")
    server.wait_for_termination()

if __name__ == '__main__':
    serve()