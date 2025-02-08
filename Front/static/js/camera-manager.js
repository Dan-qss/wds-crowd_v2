// cameraManager.js
class CameraManager {
    constructor() {
        this.cameras = {};
        this.cameraData = this.initializeCameraData();
        this.initializeCameras();
        this.setupResizeListener();
    }

    initializeCameraData() {
        return {
            '8': this.createCameraDataObject(),
            '9': this.createCameraDataObject(),
            '10': this.createCameraDataObject(),
            '11': this.createCameraDataObject(),
            '12': this.createCameraDataObject()
        };
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
        const cameraIds = ['8', '9', '10', '11', '12'];
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

    updateCanvas(camera, img) {
        if (!img) return;
        
        // Get the container dimensions
        const container = camera.canvas.parentElement;
        const containerWidth = container.clientWidth;
        const containerHeight = container.clientHeight;
        
        // Calculate the scaling ratio while maintaining aspect ratio
        const scaleWidth = containerWidth / img.width;
        const scaleHeight = containerHeight / img.height;
        const scale = Math.min(scaleWidth, scaleHeight);
        
        // Calculate new dimensions
        const width = img.width * scale;
        const height = img.height * scale;
        
        // Update canvas size
        camera.canvas.width = width;
        camera.canvas.height = height;
        
        // Clear previous frame
        camera.ctx.clearRect(0, 0, width, height);
        
        // Calculate centering
        const x = (containerWidth - width) / 2;
        const y = (containerHeight - height) / 2;
        
        // Position the canvas
        camera.canvas.style.position = 'absolute';
        camera.canvas.style.left = `${x}px`;
        camera.canvas.style.top = `${y}px`;
        
        // Draw the image
        camera.ctx.drawImage(img, 0, 0, width, height);
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
            case '8':
                elementId = 'Drons_crowd';
                percentageId = 'Drons-per';
                break;
            case '9':
                elementId = 'amr-crowd';
                percentageId = 'amr-per';
                break;
            case '10':
                elementId = 'barns-crowd';
                percentageId = 'barns-per';
                break;
            case '11':
                elementId = 'catwalk-crowd';
                percentageId = 'catwalk-per';
                break;
            case '12':
                elementId = 'Humanoid_crowd';
                percentageId = 'Humanoid-per';
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