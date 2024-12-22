// websocket.js
class WebSocketHandler {
    constructor(url, onFrameCallback) {
        this.url = url;
        this.onFrameCallback = onFrameCallback;
        this.status = document.getElementById('status');
        this.connect();
    }

    connect() {
        this.ws = new WebSocket(this.url);
        this.setupEventListeners();
    }

    setupEventListeners() {
        this.ws.onopen = () => {
            this.status.textContent = 'Connected';
            this.status.style.background = 'rgb(169, 222, 226)';
        };

        this.ws.onclose = () => {
            this.status.textContent = 'Disconnected - Reconnecting...';
            this.status.style.background = 'rgba(255, 0, 0, 0.8)';
            setTimeout(() => this.connect(), 1000);
        };

        this.ws.onerror = (error) => {
            console.error('WebSocket error:', error);
        };

        this.ws.onmessage = async (event) => {
            try {
                const data = JSON.parse(event.data);
                if (data.type === 'frame') {
                    this.onFrameCallback(data);
                }
            } catch (error) {
                console.error('Error processing message:', error);
            }
        };
    }
}

export default WebSocketHandler;