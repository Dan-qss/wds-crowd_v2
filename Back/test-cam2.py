import cv2
import time

def connect_rtsp_camera(rtsp_url, max_retries=5, retry_delay=3):
    """
    Connect to RTSP camera with retry mechanism
    
    Args:
        rtsp_url (str): RTSP camera URL
        max_retries (int): Maximum number of connection attempts
        retry_delay (int): Delay between retries in seconds
    
    Returns:
        cv2.VideoCapture: Camera object or None if failed
    """
    
    for attempt in range(max_retries):
        print(f"Connection attempt {attempt + 1}/{max_retries}...")
        
        # Create VideoCapture object
        cap = cv2.VideoCapture(rtsp_url)
        
        # Optimize connection settings
        cap.set(cv2.CAP_PROP_BUFFERSIZE, 1)
        cap.set(cv2.CAP_PROP_FPS, 30)
        
        # Test connection
        if cap.isOpened():
            ret, frame = cap.read()
            if ret and frame is not None:
                print("Successfully connected to camera!")
                return cap
            else:
                print("Failed to read frame")
                cap.release()
        else:
            print("Failed to open camera")
        
        if attempt < max_retries - 1:
            print(f"Retrying in {retry_delay} seconds...")
            time.sleep(retry_delay)
    
    print("Failed to connect to camera after all attempts")
    return None

def main():
    # Try different RTSP URLs - uncomment one at a time to test
    rtsp_urls = [
        "rtsp://admin:QSS2030qss@192.168.100.98:554/Streaming/Channels/101",  # Standard port
        "rtsp://admin:QSS2030qss@192.168.100.98:8554/Streaming/Channels/101", # Alternative port
        "rtsp://admin:QSS2030qss@192.168.100.98/cam/realmonitor?channel=1&subtype=0", # Alternative path
        "rtsp://admin:QSS2030qss@192.168.100.98/h264/ch1/main/av_stream", # H264 format
        "rtsp://admin:QSS2030qss@192.168.100.98/live/main", # Simple path
        "rtsp://admin:QSS2030qss@192.168.100.98/Streaming/Channels/1", # Channel 1
    ]
    
    # Try each URL
    for i, rtsp_url in enumerate(rtsp_urls):
        print(f"\nTrying URL {i+1}: {rtsp_url}")
        cap = test_single_url(rtsp_url)
        if cap:
            print(f"Success with URL: {rtsp_url}")
            run_stream(cap)
            return
    
    print("All URLs failed. Please check camera settings.")
def test_single_url(rtsp_url, timeout=10):
    """Test a single RTSP URL with timeout"""
    cap = cv2.VideoCapture(rtsp_url)
    cap.set(cv2.CAP_PROP_BUFFERSIZE, 1)
    
    if cap.isOpened():
        ret, frame = cap.read()
        if ret and frame is not None:
            return cap
    
    cap.release()
    return None

def run_stream(cap):
    """Run the video stream"""
    print("Live stream started. Press 'q' to quit, 's' to save screenshot")
    
    try:
        frame_count = 0
        while True:
            ret, frame = cap.read()
            
            if not ret:
                print("Connection lost or stream ended")
                break
            
            frame_count += 1
            
            # Add text overlay
            cv2.putText(frame, f"Frame: {frame_count}", (10, 30), 
                       cv2.FONT_HERSHEY_SIMPLEX, 1, (0, 255, 0), 2)
            
            cv2.putText(frame, "Press 'q' to quit, 's' to save", (10, 70), 
                       cv2.FONT_HERSHEY_SIMPLEX, 0.7, (0, 255, 0), 2)
            
            # Display frame
            cv2.imshow('RTSP Camera Stream', frame)
            
            # Handle key presses
            key = cv2.waitKey(1) & 0xFF
            if key == ord('q'):
                print("Stream stopped")
                break
            elif key == ord('s'):
                filename = f"screenshot_{frame_count}.jpg"
                cv2.imwrite(filename, frame)
                print(f"Screenshot saved: {filename}")
    
    except KeyboardInterrupt:
        print("\nProgram interrupted by user")
    
    finally:
        if cap:
            cap.release()
        cv2.destroyAllWindows()
        print("All windows closed")

def check_camera_connection():
    """Check basic network connectivity to camera"""
    import subprocess
    import socket
    
    ip = "192.168.100.96"
    ports = [554, 8554, 80, 8080]
    
    print(f"Testing network connectivity to {ip}...")
    
    # Ping test
    try:
        result = subprocess.run(['ping', '-c', '1', ip], 
                              capture_output=True, text=True, timeout=10)
        if result.returncode == 0:
            print("✓ Ping successful")
        else:
            print("✗ Ping failed")
    except:
        print("✗ Ping test failed")
    
    # Port test
    for port in ports:
        try:
            sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
            sock.settimeout(3)
            result = sock.connect_ex((ip, port))
            if result == 0:
                print(f"✓ Port {port} is open")
            else:
                print(f"✗ Port {port} is closed/filtered")
            sock.close()
        except:
            print(f"✗ Cannot test port {port}")

def debug_rtsp_connection():
    """Debug RTSP connection with detailed output"""
    import os
    
    # Set FFmpeg debug level
    os.environ['OPENCV_FFMPEG_CAPTURE_OPTIONS'] = 'rtsp_transport;udp'
    
    rtsp_url = "rtsp://admin:QSS2030qss@192.168.100.96:554/Streaming/Channels/101"
    
    print("Debug mode - testing with UDP transport...")
    
    cap = cv2.VideoCapture(rtsp_url, cv2.CAP_FFMPEG)
    
    if cap.isOpened():
        print("✓ Stream opened successfully")
        ret, frame = cap.read()
        if ret:
            print("✓ Frame read successfully")
            cv2.imshow('Debug Stream', frame)
            cv2.waitKey(5000)  # Show for 5 seconds
        else:
            print("✗ Failed to read frame")
    else:
        print("✗ Failed to open stream")
    
    cap.release()
    cv2.destroyAllWindows()

# Simple version for quick testing
def simple_rtsp_stream():
    """Simplified version for quick testing"""
    rtsp_url = "rtsp://admin:QSS2030qss@@192.168.100.96/Streaming/Channels/101"
    
    # Open camera
    cap = cv2.VideoCapture(rtsp_url)
    
    if not cap.isOpened():
        print("Error: Cannot open camera")
        return
    
    print("Camera opened successfully. Press 'q' to quit")
    
    while True:
        ret, frame = cap.read()
        if not ret:
            print("Failed to read frame")
            break
            
        cv2.imshow('RTSP Stream', frame)
        
        if cv2.waitKey(1) & 0xFF == ord('q'):
            break
    
    cap.release()
    cv2.destroyAllWindows()

# Advanced version with error handling and reconnection
def advanced_rtsp_stream():
    """Advanced version with automatic reconnection"""
    rtsp_url = "rtsp://admin:QSS2030qss@@192.168.100.98/Streaming/Channels/101"
    reconnect_delay = 5
    
    while True:
        cap = cv2.VideoCapture(rtsp_url)
        
        if not cap.isOpened():
            print("Failed to connect. Retrying in 5 seconds...")
            time.sleep(reconnect_delay)
            continue
        
        print("Connected! Press 'q' to quit")
        
        while True:
            ret, frame = cap.read()
            
            if not ret:
                print("Connection lost. Reconnecting...")
                break
            
            cv2.imshow('RTSP Stream', frame)
            
            key = cv2.waitKey(1) & 0xFF
            if key == ord('q'):
                cap.release()
                cv2.destroyAllWindows()
                return
        
        cap.release()
        time.sleep(reconnect_delay)

if __name__ == "__main__":
    print("=== RTSP Camera Connection Tool ===")
    print("1. Testing network connectivity...")
    check_camera_connection()
    
    print("\n2. Trying different RTSP URLs...")
    main()
    
    print("\n3. If still failing, try debug mode...")
    # Uncomment the next line if other methods fail
    # debug_rtsp_connection()