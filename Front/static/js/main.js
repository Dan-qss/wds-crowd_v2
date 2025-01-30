// main.js
import WebSocketHandler from './websocket-handler.js';
import CameraManager from './camera-manager.js';
import ChartManager from './line-chart-manager.js';
import PieChartManager from './pie-chart-manager.js';
import PieChart2Manager from './pie-chart2-manager.js';
import FaceListManager from './face-list-manager.js';

document.addEventListener('DOMContentLoaded', () => {
    const cameraManager = new CameraManager();
    const chartManager = new ChartManager();
    const pieChartManager = new PieChartManager();
    const pieChart2Manager = new PieChart2Manager(); // Now includes auto-updating
    const faceListManager = new FaceListManager();
    
    const wsHandler = new WebSocketHandler('ws://192.168.100.65:8765', (data) => {
        cameraManager.handleFrame(data);
        if (data.pieChartData) {
            pieChartManager.handleWebSocketData(data.pieChartData);
        }
    });

    // Clean up on page unload
    window.addEventListener('beforeunload', () => {
        if (pieChart2Manager) {
            pieChart2Manager.destroy();
        }
    });
});