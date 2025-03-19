// cameraManager.js
class CameraManager {
    constructor() {
        this.cameras = {};
        this.cameraData = this.initializeCameraData();
        this.initializeCameras();
        this.setupResizeListener();
        this.currentCamera2 = '2';
        this.setupCameraSwitching();
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

    // Add these methods to your camera-manager.js file

/**
 * Creates a "No Stream" image to display when camera is offline
 * @param {number} width - Canvas width 
 * @param {number} height - Canvas height
 * @returns {HTMLImageElement} - Image with "No Stream" message
 */
createNoStreamImage(width, height) {
    // Create an off-screen canvas to generate the "No Stream" image
    const canvas = document.createElement('canvas');
    canvas.width = width || 640;
    canvas.height = height || 360;
    const ctx = canvas.getContext('2d');
    
    // Draw black background
    ctx.fillStyle = '#000000';
    ctx.fillRect(0, 0, canvas.width, canvas.height);
    
    // Draw "No Stream" text
    ctx.fillStyle = '#FFFFFF';
    ctx.font = 'bold 30px Arial';
    ctx.textAlign = 'center';
    ctx.textBaseline = 'middle';
    ctx.fillText('No Stream', canvas.width / 2, canvas.height / 2);
    
    // Convert canvas to image
    const img = new Image();
    img.src = canvas.toDataURL('image/png');
    return img;
}

/**
 * Displays a "No Stream" message on the specified camera canvas
 * @param {string} cameraId - The ID of the camera
 */
showNoStreamMessage(cameraId) {
    let camera;
    
    // Special handling for cameras 2 and 3
    if (cameraId === '2' || cameraId === '3') {
        camera = this.cameras['2']; // Always use camera 2's canvas
    } else {
        camera = this.cameras[cameraId];
    }
    
    if (!camera || !camera.canvas || !camera.ctx) {
        console.error(`Cannot display "No Stream" message: invalid camera ${cameraId}`);
        return;
    }
    
    // Get canvas dimensions
    const width = camera.canvas.width || 640;
    const height = camera.canvas.height || 360;
    
    // Create and display the "No Stream" image
    const noStreamImg = this.createNoStreamImage(width, height);
    noStreamImg.onload = () => {
        camera.ctx.drawImage(noStreamImg, 0, 0, width, height);
    };
}
}

export default CameraManager;