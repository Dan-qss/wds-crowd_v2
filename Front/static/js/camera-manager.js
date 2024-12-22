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
    
            // Process and store the frame
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
                    this.updateCanvas(camera, img); // Pass the image directly
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
                camera.lastFrame = img;
                this.updateCanvas(camera, img);
                URL.revokeObjectURL(imageUrl);
            };
            img.src = imageUrl;
        }
    }
    
    // Modified updateCanvas to accept an image parameter
    updateCanvas(camera, img) {
        const containerAspect = camera.canvas.clientWidth / camera.canvas.clientHeight;
        const imageAspect = img.width / img.height;
        
        let drawWidth = camera.canvas.clientWidth;
        let drawHeight = camera.canvas.clientHeight;
        
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