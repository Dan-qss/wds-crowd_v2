import grpc
import camera_service_pb2
import camera_service_pb2_grpc
import cv2
import numpy as np
from concurrent.futures import ThreadPoolExecutor
import time
import logging
from ultralytics import YOLO
from queue import Queue, Full, Empty
import threading
import torch
import os
import sys

# Configure logging
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(levelname)s - %(message)s',
    handlers=[
        logging.FileHandler('client_logs.log'),
        logging.StreamHandler()
    ]
)
logger = logging.getLogger(__name__)

class CameraProcessor:
    def __init__(self, model_path='yolov8n.pt', max_queue_size=1):
        # Check GPU availability
        self.device = 'cuda' if torch.cuda.is_available() else 'cpu'
        logger.info(f"Using device: {self.device}")
        if self.device == 'cuda':
            logger.info(f"GPU: {torch.cuda.get_device_name()}")
        
        # Load model and ensure it's on GPU if available
        try:
            self.model = YOLO(model_path)
            if self.device == 'cuda':
                torch.cuda.set_device(0)  # Set the GPU device
        except Exception as e:
            logger.error(f"Error loading model: {e}")
            raise
        
        self.frame_queues = {}
        self.result_queues = {}
        self.max_queue_size = max_queue_size
        self.running = True
        self.inference_thread = None
        self.processing_enabled = True  # Flag to toggle processing
        
    def start_inference_thread(self):
        self.inference_thread = threading.Thread(target=self._inference_worker)
        self.inference_thread.daemon = True
        self.inference_thread.start()
        
    def add_camera(self, camera_id):
        self.frame_queues[camera_id] = Queue(maxsize=self.max_queue_size)
        self.result_queues[camera_id] = Queue(maxsize=self.max_queue_size)
        
    def _inference_worker(self):
        while self.running:
            if not self.processing_enabled:
                time.sleep(0.1)
                continue

            # Process frames from all cameras
            for camera_id, frame_queue in self.frame_queues.items():
                if not frame_queue.empty():
                    try:
                        frame = frame_queue.get_nowait()
                        # Run inference with YOLO
                        results = self.model(frame, conf=0.30, verbose=False, classes=[0], device=0)
                        # Draw bounding boxes and labels
                        processed_frame = results[0].plot(conf=False, labels=False)
                        
                        # Calculate people count
                        people_count = len(results[0].boxes)
                        # Draw people count on frame
                        cv2.putText(
                            processed_frame, 
                            f'People: {people_count}', 
                            (10, 30), 
                            cv2.FONT_HERSHEY_SIMPLEX, 
                            1, 
                            (0, 255, 0), 
                            2
                        )
                        
                        try:
                            self.result_queues[camera_id].put_nowait(processed_frame)
                        except Full:
                            continue
                            
                    except Empty:
                        continue
                    except Exception as e:
                        logger.error(f"Inference error for camera {camera_id}: {e}")
            
            time.sleep(0.001)  # Small sleep to prevent CPU overload
            
    def toggle_processing(self):
        self.processing_enabled = not self.processing_enabled
        logger.info(f"Processing {'enabled' if self.processing_enabled else 'disabled'}")
            
    def stop(self):
        self.running = False
        if self.inference_thread:
            self.inference_thread.join()
        # Clean up GPU memory
        if self.device == 'cuda':
            torch.cuda.empty_cache()

def process_camera_stream(stub, camera_id, processor):
    """Process stream for a single camera"""
    logger.info(f"Starting stream for camera {camera_id}")
    request = camera_service_pb2.FrameRequest(camera_id=camera_id)
    processor.add_camera(camera_id)
    
    try:
        for response in stub.StreamFrames(request):
            frame_data = np.frombuffer(response.frame_data, dtype=np.uint8)
            frame = cv2.imdecode(frame_data, cv2.IMREAD_COLOR)
            
            if frame is not None:
                # Add frame to processing queue if there's room
                try:
                    processor.frame_queues[camera_id].put_nowait(frame)
                except Full:
                    pass
                
                # Display processed frame if available, otherwise show original
                try:
                    if not processor.result_queues[camera_id].empty():
                        display_frame = processor.result_queues[camera_id].get_nowait()
                    else:
                        display_frame = frame
                except Empty:
                    display_frame = frame
                
                window_name = f'Camera {camera_id}'
                cv2.imshow(window_name, display_frame)
                
                # Position windows in grid layout
                window_width = 640
                window_height = 480
                screen_cols = 3
                idx = int(camera_id) - 1
                col = idx % screen_cols
                row = idx // screen_cols
                cv2.moveWindow(window_name, col * window_width, row * window_height)
                
                key = cv2.waitKey(1) & 0xFF
                if key == ord('q'):
                    return
                elif key == ord('p'):
                    processor.toggle_processing()
            
    except grpc.RpcError as e:
        logger.error(f"Stream error for camera {camera_id}: {e}")
    except Exception as e:
        logger.error(f"Unexpected error for camera {camera_id}: {e}")
    finally:
        logger.info(f"Stream ended for camera {camera_id}")

def create_grpc_channel():
    """Create and configure gRPC channel with optimized settings"""
    return grpc.insecure_channel(
        'localhost:50051',
        options=[
            ('grpc.max_send_message_length', 100 * 1024 * 1024),
            ('grpc.max_receive_message_length', 100 * 1024 * 1024),
            ('grpc.enable_retries', 1),
            ('grpc.keepalive_time_ms', 60000),
            ('grpc.keepalive_timeout_ms', 20000),
            ('grpc.keepalive_permit_without_calls', 1),
            ('grpc.http2.max_pings_without_data', 5),
            ('grpc.http2.min_time_between_pings_ms', 60000),
            ('grpc.http2.min_ping_interval_without_data_ms', 60000)
        ]
    )

def main():
    camera_ids = ["1", "2", "3", "4", "5"]
    
    # Create channel and stub
    channel = create_grpc_channel()
    stub = camera_service_pb2_grpc.CameraServiceStub(channel)
    
    # Initialize processor
    try:
        processor = CameraProcessor()
        processor.start_inference_thread()
    except Exception as e:
        logger.error(f"Failed to initialize processor: {e}")
        return
    
    try:
        # Start camera streams one by one
        executors = []
        for camera_id in camera_ids:
            executor = ThreadPoolExecutor(max_workers=1)
            future = executor.submit(process_camera_stream, stub, camera_id, processor)
            executors.append((executor, future))
            time.sleep(1)  # Delay between camera starts
        
        print("\nControls:")
        print("Press 'q' to quit")
        print("Press 'p' to toggle processing (enable/disable people detection)")
        
        # Keep main thread alive
        while True:
            if cv2.waitKey(1) & 0xFF == ord('q'):
                break
            time.sleep(0.01)
            
    except KeyboardInterrupt:
        logger.info("Received interrupt signal")
    except Exception as e:
        logger.error(f"Main loop error: {e}")
    finally:
        # Cleanup
        processor.stop()
        for executor, future in executors:
            future.cancel()
            executor.shutdown(wait=False)
        cv2.destroyAllWindows()
        channel.close()
        logger.info("Client shutdown complete")

if __name__ == '__main__':
    main()