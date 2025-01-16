# Crowd Management System

A comprehensive system for real-time crowd monitoring and analysis using computer vision and distributed processing.

## System Overview

The Crowd Management System is a sophisticated solution that processes video feeds from multiple cameras to detect, track, and analyze crowd patterns in real-time. The system utilizes YOLO-based models for person detection and implements a distributed architecture for efficient processing.

### Key Features

- Multi-camera support with dedicated processing queues
- Real-time video stream processing at 30 FPS
- Person detection using multiple YOLO models
- Distributed processing architecture with gRPC communication
- JSON-based detection results and image storage
- Web-based monitoring interface
- PostgreSQL database integration for data storage and analysis

## Architecture

The system consists of three main components:

1. Camera System (Backend)
   - Manages camera connections and video streams
   - Implements gRPC services for communication
   - Handles ROI (Region of Interest) configurations

2. Optimized Client
   - Processes video frames through multiple AI models
   - Implements frame processing pipeline
   - Manages detection queues and results

3. Database System
   - Stores detection results and analytics
   - Provides API endpoints for data access
   - Implements data partitioning for efficient storage

## Prerequisites

- Python 3.8+
- PostgreSQL database
- CUDA-capable GPU (recommended)

## Installation

1. Clone the repository:
```bash
git clone https://github.com/yourusername/crowd-management.git
cd crowd-management
```

2. Install required packages:
```bash
pip install -r requirements.txt
```

3. Set up the databases:
```bash
cd Back/database/camera_system_database
psql -U postgres -f camera_system.sql

cd ../crowd_management_database
psql -U postgres -f crowd_management.sql
```

## Configuration

1. Configure camera ROIs in `Back/camera_system/roi.py`
2. Update database configurations in:
   - `Back/database/camera_system_database/db_config.py`
   - `Back/database/crowd_management_database/db_configuration.py`

## Running the System

1. Start the Camera Server:
```bash
cd crowd_management/Back/camera_system
python camera_server.py
```

2. Launch the Optimized Client:
```bash
cd crowd_management/Back/client
python optimized_client.py
```

3. Start the API Server:
```bash
cd crowd_management/Back/database/crowd_management_database
python crowd-management-api.py
```

## Project Structure

```
crowd_management/
├── Back/
│   ├── camera_system/       # Camera management and video streaming
│   ├── client/              # Frame processing and AI models
│   ├── database/            # Data storage and API
│   ├── logs/                # System logs
│   └── results/             # Detection results
├── Front/
│   ├── html/              # Web interface
│   └── static/            # Static assets
```

## Technical Details

### Core Features
- Real-time video processing at 30 FPS
- Multi-camera support with ROI (Region of Interest) configuration
- Automatic frame resizing and compression for optimal performance
- WebSocket streaming for real-time web interface updates

### Camera Zones
- Software Room
- Robotics Lab
- Marketing & Sales
- Showroom


### AI Models
- Model 1: Person Detection (conf: 0.30) - Primary crowd detection
- Model 2: Face Recognition (conf: 0.40) - Facial detection and recognition
- Extensible architecture for additional models

### System Architecture
- gRPC server for high-performance video streaming
- PostgreSQL databases for data persistence
- Error logging system for monitoring and debugging
- Queue-based frame management for optimal resource usage


## Acknowledgments

- YOLOv8 for object detection models
- FastAPI for API development
- gRPC for efficient communication
