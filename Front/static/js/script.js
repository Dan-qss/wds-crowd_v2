const cameras = {};
const status = document.getElementById('status');

// Store data for each camera with batch processing
const cameraData = {
    '1': {
        percentages: [],
        crowdingLevels: [],
        latestAverage: null,
        latestCrowdingMode: null,
        batchSize: 11
    },
    '2': {
        percentages: [],
        crowdingLevels: [],
        latestAverage: null,
        latestCrowdingMode: null,
        batchSize: 11
    },
    '3': {
        percentages: [],
        crowdingLevels: [],
        latestAverage: null,
        latestCrowdingMode: null,
        batchSize: 11
    },
    '4': {
        percentages: [],
        crowdingLevels: [],
        latestAverage: null,
        latestCrowdingMode: null,
        batchSize: 11
    }
};

// Initialize canvas contexts for each camera
for (let i = 1; i <= 4; i++) {
    const canvas = document.getElementById(`camera${i}`);
    if (canvas) {
        const ctx = canvas.getContext('2d');
        cameras[i] = {
            canvas: canvas,
            ctx: ctx,
            lastFrame: null
        };
    }
}

function connectWebSocket() {
    const ws = new WebSocket('ws://localhost:8765');

    ws.onopen = () => {
        status.textContent = 'Connected';
        status.style.background = 'rgba(0, 255, 0, 0.8)';
    };

    ws.onclose = () => {
        status.textContent = 'Disconnected - Reconnecting...';
        status.style.background = 'rgba(255, 0, 0, 0.8)';
        setTimeout(connectWebSocket, 1000);
    };

    ws.onerror = (error) => {
        console.error('WebSocket error:', error);
    };

    ws.onmessage = async (event) => {
        try {
            const data = JSON.parse(event.data);
            if (data.type === 'frame') {
                updateHeatMap(data);
                handleCameraFrame(data);
            }
        } catch (error) {
            console.error('Error processing message:', error);
        }
    };
}

function handleCameraFrame(data) {
    const cameraId = data.camera_id;
    const camera = cameras[cameraId];
    
    if (!camera) return;

    // Decode base64 and decompress
    const compressedData = atob(data.frame);
    const compressedArray = Uint8Array.from(compressedData, c => c.charCodeAt(0));
    const decompressedArray = pako.inflate(compressedArray);
    
    // Convert to blob and create image
    const blob = new Blob([decompressedArray], { type: 'image/jpeg' });
    const imageUrl = URL.createObjectURL(blob);
    
    const img = new Image();
    img.onload = () => {
        camera.lastFrame = img;
        updateCanvas(camera);
        URL.revokeObjectURL(imageUrl);
    };
    img.src = imageUrl;
}

function updateCanvas(camera) {
    const containerAspect = camera.canvas.clientWidth / camera.canvas.clientHeight;
    const imageAspect = camera.lastFrame.width / camera.lastFrame.height;
    
    let drawWidth = camera.canvas.clientWidth;
    let drawHeight = camera.canvas.clientHeight;
    
    if (containerAspect > imageAspect) {
        drawWidth = drawHeight * imageAspect;
    } else {
        drawHeight = drawWidth / imageAspect;
    }
    
    camera.canvas.width = drawWidth;
    camera.canvas.height = drawHeight;
    camera.ctx.drawImage(camera.lastFrame, 0, 0, drawWidth, drawHeight);
}

function calculateMode(arr) {
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

function calculateAverageAndMode(cameraId, percentage, crowdingLevel) {
    const camera = cameraData[cameraId];
    if (camera) {
        // Add new values to arrays
        camera.percentages.push(percentage);
        camera.crowdingLevels.push(crowdingLevel);
        
        // When we have enough readings, calculate both average and mode
        if (camera.percentages.length === camera.batchSize) {
            // Calculate average for percentages
            const sum = camera.percentages.reduce((a, b) => a + b, 0);
            const average = Math.round(sum / camera.batchSize);
            camera.latestAverage = average;
            
            // Calculate mode for crowding levels
            const mode = calculateMode(camera.crowdingLevels);
            camera.latestCrowdingMode = mode;
            
            console.log(`Camera ${cameraId} - New average: ${average}%, Mode crowding level: ${mode}`);
            
            // Clear arrays for next batch
            camera.percentages = [];
            camera.crowdingLevels = [];
        }
        
        // Return both latest values
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

function updateHeatMap(data) {
    let elementId, percentageId;
    let percentage = data.status.percentage;
    let crowdingLevel = data.status.crowding_level;
    
    // Calculate both average and mode
    const stats = calculateAverageAndMode(data.camera_id, percentage, crowdingLevel);

    switch(data.camera_id) {
        case '1':
            elementId = 'software_crowd';
            percentageId = 'software-per';
            break;
        case '4':
            elementId = 'lobby-crowd';
            percentageId = 'lobby-per';
            break;
        case '2':
            elementId = 'Robotics_lab-crowd';
            percentageId = 'Robotics_lab-per';
            break;
        case '3':
            elementId = 'show_room_crowd';
            percentageId = 'show-room-per';
            break;
        default:
            console.warn('Unknown camera_id:', data.camera_id);
            return;
    }

    const element = document.getElementById(elementId);
    const percentageElement = document.getElementById(percentageId);

    if (element && stats.crowdingMode) {
        updateElementStyle(element, stats.crowdingMode);
    }

    if (percentageElement) {
        updatePercentage(percentageElement, stats.crowdingMode, stats.average);
    }
}

function updateElementStyle(element, crowdingLevel) {
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

function updatePercentage(element, crowdingLevel, average) {
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

window.addEventListener('resize', () => {
    for (const camera of Object.values(cameras)) {
        if (camera.lastFrame) {
            updateCanvas(camera);
        }
    }
});

// Start connection
connectWebSocket();