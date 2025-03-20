// cameraManager.js
class CameraManager {
    constructor() {
        this.cameras = {};
        this.cameraData = this.initializeCameraData();
        this.initializeCameras();
        this.setupResizeListener();
        this.currentCamera2 = '2';
        this.setupCameraSwitching();
        
        // Add frame monitoring
        this.lastFrameTimestamps = {
            '1': Date.now(),
            '2': Date.now(),
            '3': Date.now(),
            '4': Date.now(),
            '5': Date.now()
        };
        this.cameraMonitoringInterval = 5000; // Check every 10 seconds
        this.frameTimeoutThreshold = 10000; // Consider camera down after 15 seconds without frames
        this.startCameraMonitoring();
    }

    // Start the camera monitoring system
    startCameraMonitoring() {
        setInterval(() => {
            const now = Date.now();
            for (const cameraId in this.lastFrameTimestamps) {
                const timeSinceLastFrame = now - this.lastFrameTimestamps[cameraId];
                if (timeSinceLastFrame > this.frameTimeoutThreshold) {
                    console.log(`Camera id ${cameraId} no frames for ${Math.round(timeSinceLastFrame/1000)}s`);
                    
                    // Update UI to show camera is offline
                    this.updateCameraOfflineStatus(cameraId, true);
                    
                    // Directly show "NO STREAM" on canvas
                    this.showNoStreamMessage(cameraId);
                } else if (timeSinceLastFrame > this.cameraMonitoringInterval) {
                    // Warning level - frames are delayed but not completely stopped
                    console.log(`Camera id ${cameraId} frames delayed for ${Math.round(timeSinceLastFrame/1000)}s`);
                }
            }
        }, this.cameraMonitoringInterval);
    }
    
    // Update UI to show camera offline status
    updateCameraOfflineStatus(cameraId, isOffline) {
        // Find the camera container or status element
        let cameraElement;
        switch(cameraId) {
            case '1':
                cameraElement = document.getElementById('software_crowd');
                break;
            case '2':
            case '3':
                cameraElement = document.getElementById('Robotics_lab-crowd');
                break;
            case '4':
                cameraElement = document.getElementById('show_room_crowd');
                break;
            case '5':
                cameraElement = document.getElementById('lobby-crowd');
                break;
        }
        
        if (cameraElement) {
            if (isOffline) {
                // Add offline indicator
                cameraElement.classList.add('camera-offline');
                
                // Find the percentage element and update text
                const percentId = cameraElement.id.replace('-crowd', '-per');
                const percentElement = document.getElementById(percentId);
                if (percentElement) {
                    percentElement.textContent = 'Offline';
                    percentElement.style.color = '#FF0000';
                }
                
                // Show "NO STREAM" text on the canvas
                this.showNoStreamMessage(cameraId);
            } else {
                // Remove offline indicator
                cameraElement.classList.remove('camera-offline');
            }
        }
    }
    
    showNoStreamMessage(cameraId) {
        // For cameras 2 and 3, we need to use camera canvas '2'
        const displayCameraId = (cameraId === '2' || cameraId === '3') ? '2' : cameraId;
        const camera = this.cameras[displayCameraId];
        
        if (camera && camera.canvas && camera.ctx) {
            // Clear the canvas
            camera.ctx.clearRect(0, 0, camera.canvas.width, camera.canvas.height);
            
            // Set canvas dimensions if not already set
            if (camera.canvas.width === 0) camera.canvas.width = 640;
            if (camera.canvas.height === 0) camera.canvas.height = 360;
            
            // Fill canvas with dark background
            camera.ctx.fillStyle = 'rgba(0, 0, 0, 0.7)';
            camera.ctx.fillRect(0, 0, camera.canvas.width, camera.canvas.height);
            
            // Draw text "NO STREAM"
            camera.ctx.font = 'bold 36px Arial';
            camera.ctx.textAlign = 'center';
            camera.ctx.textBaseline = 'middle';
            
            // Text shadow for better visibility
            camera.ctx.fillStyle = 'rgba(0, 0, 0, 0.8)';
            camera.ctx.fillText('NO STREAM', camera.canvas.width / 2 + 2, camera.canvas.height / 2 + 2);
            
            // Main text in red
            camera.ctx.fillStyle = '#FF0000';
            camera.ctx.fillText('NO STREAM', camera.canvas.width / 2, camera.canvas.height / 2);
            
            // Additional info text
            camera.ctx.font = '16px Arial';
            camera.ctx.fillStyle = '#FFFFFF';
            camera.ctx.fillText(`Camera ${cameraId} offline`, camera.canvas.width / 2, camera.canvas.height / 2 + 40);
        }
    }

    initializeCameraData() {
        return {
            '1': this.createCameraDataObject(),
            '2': this.createCameraDataObject(),
            '3': this.createCameraDataObject(),
            '4': this.createCameraDataObject(),
            '5': this.createCameraDataObject()
        };
    }

    setupCameraSwitching() {
        setInterval(() => {
            this.currentCamera2 = this.currentCamera2 === '2' ? '3' : '2';
            // If there's a last frame for the new camera, display it
            const newCamera = this.cameras[this.currentCamera2];
            if (newCamera && newCamera.lastFrame) {
                this.updateCanvas(newCamera);
            }
        }, 5000);
    }

    createCameraDataObject() {
        return {
            percentages: [],
            crowdingLevels: [],
            latestAverage: null,
            latestCrowdingMode: null,
            batchSize: 11
        };
    }

    initializeCameras() {
        const cameraIds = ['1', '2', '3', '4', '5'];
        for (let id of cameraIds) {
            const canvas = document.getElementById(`camera${id}`);
            if (canvas) {
                const ctx = canvas.getContext('2d');
                this.cameras[id] = {
                    canvas: canvas,
                    ctx: ctx,
                    lastFrame: null
                };
            }
        }
    }

    setupResizeListener() {
        window.addEventListener('resize', () => {
            for (const camera of Object.values(this.cameras)) {
                if (camera.lastFrame) {
                    this.updateCanvas(camera);
                }
            }
        });
    }

    handleFrame(data) {
        // Update timestamp when a frame is received
        const cameraId = data.camera_id;
        this.lastFrameTimestamps[cameraId] = Date.now();
        
        this.updateHeatMap(data);
        this.handleCameraFrame(data);
    }

    handleCameraFrame(data) {
        const cameraId = data.camera_id;
        // Special handling for cameras 2 and 5
        if (cameraId === '2' || cameraId === '3') {
            const camera = this.cameras['2']; // Always use camera 2's canvas
            if (!camera) return;
    
            const compressedData = atob(data.frame);
            const compressedArray = Uint8Array.from(compressedData, c => c.charCodeAt(0));
            const decompressedArray = pako.inflate(compressedArray);
            
            const blob = new Blob([decompressedArray], { type: 'image/jpeg' });
            const imageUrl = URL.createObjectURL(blob);
            
            const img = new Image();
            img.onload = () => {
                // Store the frame in the appropriate camera object
                this.cameras[cameraId].lastFrame = img;
                // Only update display if this is the currently active camera
                if (cameraId === this.currentCamera2) {
                    this.updateCanvas(camera, img);
                }
                URL.revokeObjectURL(imageUrl);
            };
            img.src = imageUrl;
        } else {
            // Handle other cameras normally
            const camera = this.cameras[cameraId];
            if (!camera) return;
    
            const compressedData = atob(data.frame);
            const compressedArray = Uint8Array.from(compressedData, c => c.charCodeAt(0));
            const decompressedArray = pako.inflate(compressedArray);
            const blob = new Blob([decompressedArray], { type: 'image/jpeg' });
            const imageUrl = URL.createObjectURL(blob);
            
            const img = new Image();
            img.onload = () => {
                // console.log(`Client decoded image dimensions for camera ${cameraId}: ${img.width}x${img.height}`);
                camera.lastFrame = img;
                this.updateCanvas(camera, img);
            
                // Log final display dimensions
                URL.revokeObjectURL(imageUrl);
            };
            img.src = imageUrl;
        }
    }

    updateCanvas(camera, img) {
        // Set minimum dimensions for better visibility
        const minWidth = 640;  // Set minimum width
        const minHeight = 360; // Set minimum height
        
        // Calculate scaling while maintaining aspect ratio
        const containerAspect = camera.canvas.clientWidth / camera.canvas.clientHeight;
        const imageAspect = img.width / img.height;
        
        let drawWidth = Math.max(camera.canvas.clientWidth, minWidth);
        let drawHeight = Math.max(camera.canvas.clientHeight, minHeight);
        
        if (containerAspect > imageAspect) {
            drawWidth = drawHeight * imageAspect;
        } else {
            drawHeight = drawWidth / imageAspect;
        }
        
        camera.canvas.width = drawWidth;
        camera.canvas.height = drawHeight;
        camera.ctx.drawImage(img, 0, 0, drawWidth, drawHeight);
    }

    calculateMode(arr) {
        const frequency = {};
        let maxFrequency = 0;
        let mode = null;

        arr.forEach(value => {
            frequency[value] = (frequency[value] || 0) + 1;
            if (frequency[value] > maxFrequency) {
                maxFrequency = frequency[value];
                mode = value;
            }
        });

        return mode;
    }

    calculateAverageAndMode(cameraId, percentage, crowdingLevel) {
        const camera = this.cameraData[cameraId];
        if (camera) {
            camera.percentages.push(percentage);
            camera.crowdingLevels.push(crowdingLevel);
            
            if (camera.percentages.length === camera.batchSize) {
                const sum = camera.percentages.reduce((a, b) => a + b, 0);
                const average = Math.round(sum / camera.batchSize);
                camera.latestAverage = average;
                
                const mode = this.calculateMode(camera.crowdingLevels);
                camera.latestCrowdingMode = mode;
                
                // console.log(`Camera ${cameraId} - New average: ${average}%, Mode crowding level: ${mode}`);
                
                camera.percentages = [];
                camera.crowdingLevels = [];
            }
            
            return {
                average: camera.latestAverage,
                crowdingMode: camera.latestCrowdingMode
            };
        }
        return {
            average: null,
            crowdingMode: null
        };
    }

    updateHeatMap(data) {
        let elementId, percentageId;
        let percentage = data.status.crowding_percentage;
        let crowdingLevel = data.status.crowding_level;
        
        const stats = this.calculateAverageAndMode(data.camera_id, percentage, crowdingLevel);

        switch(data.camera_id) {
            case '1':
                elementId = 'software_crowd';
                percentageId = 'software-per';
                break;

            case '2':
                elementId = 'Robotics_lab-crowd';
                percentageId = 'Robotics_lab-per';
                break;

            case '4':
                elementId = 'show_room_crowd';
                percentageId = 'show-room-per';
                break;
           
            case '3':
                // console.log('Camera 3');
                // elementId = 'show_room_crowd';
                // percentageId = 'show-room-per';
                break;
            case '5':
                // console.log('Camera 5');
                elementId = 'lobby-crowd';
                percentageId = 'lobby-per';
                break;
            default:
                console.warn('Unknown camera_id:', data.camera_id);
                return;
        }

        const element = document.getElementById(elementId);
        const percentageElement = document.getElementById(percentageId);

        if (element && stats.crowdingMode) {
            this.updateElementStyle(element, stats.crowdingMode);
        }

        if (percentageElement) {
            this.updatePercentage(percentageElement, stats.crowdingMode, stats.average);
        }
    }

    updateElementStyle(element, crowdingLevel) {
        let backgroundColor, boxShadowColor;
        switch(crowdingLevel) {
            case 'Crowded':
                backgroundColor = 'var(--heavy_crowd)';
                boxShadowColor = 'var(--heavy_crowd_shadow)';
                break;
            case 'Moderate':
                backgroundColor = 'var(--moderate_crowd)';
                boxShadowColor = 'var(--moderate_crowdc_shadow)';
                break;
            case 'Low':
                backgroundColor = 'var(--no_crowd)';
                boxShadowColor = 'var(--no_crowd_shadow)';
                break;
        }

        element.style.backgroundColor = backgroundColor;
        element.style.boxShadow = `0px 0px 25px 15px ${boxShadowColor}`;
    }

    updatePercentage(element, crowdingLevel, average) {
        let displayText = `${Math.round(average)}%`;
        element.textContent = displayText;
        
        switch(crowdingLevel) {
            case 'Low':
                element.style.color = '#81FF76';
                break;
            case 'Moderate':
                element.style.color = '#FFD700';
                break;
            case 'Crowded':
                element.style.color = '#FF4500';
                break;
            default:
                element.style.color = '#FFFFFF';
        }
    }
}

export default CameraManager;