// static/js/websocket-handler.js
class WebSocketHandler {
  constructor(url, onFrameCallback) {
    this.url = url;
    this.onFrameCallback = onFrameCallback;
    this.status = document.getElementById('status') || document.getElementById('ws-status'); // لو غيرتي id
    this.manualClose = false;
    this.connect();
  }

  connect() {
    this.ws = new WebSocket(this.url);
    this.setupEventListeners();
  }

  setupEventListeners() {
    this.ws.onopen = () => {
      if (this.status) {
        this.status.textContent = 'Connected';
        this.status.style.background = 'rgb(169, 222, 226)';
        this.status.style.color = '#000';
      }
    };

    this.ws.onclose = () => {
      if (this.status) {
        this.status.textContent = 'Disconnected - Reconnecting...';
        this.status.style.background = 'rgba(255, 0, 0, 0.8)';
        this.status.style.color = '#fff';
      }
      if (!this.manualClose) setTimeout(() => this.connect(), 1000);
    };

    this.ws.onerror = (error) => {
      console.error('WebSocket error:', error);
    };

    this.ws.onmessage = (event) => {
      try {
        const data = JSON.parse(event.data);
        if (data.type === 'frame') {
          this.onFrameCallback?.(data);
        }
      } catch (error) {
        console.error('Error processing message:', error);
      }
    };
  }

  close() {
    this.manualClose = true;
    try { this.ws?.close(); } catch {}
  }
}

export default WebSocketHandler;
