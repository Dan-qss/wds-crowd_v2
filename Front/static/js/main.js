import WebSocketHandler from './websocket-handler.js';
import CameraManager from './camera-manager.js';
import FaceListManager from './face-list-manager.js';
import VisitorListManager from './unknown-list-manager.js';
import PieChartManagerfm from './pie-chart-fm.js';
import PieChartManagerbw from './pie-chart-bw.js';
import PieChartCrowded from './pie-chart-crowded.js';
import SeriesLineCrowded from './series-line-crowded.js';
import SeriesLineDays from './series-line-dyes.js';
import VisitorCounter from './visitor-counter.js';

document.addEventListener('DOMContentLoaded', () => {
    const cameraManager = new CameraManager();
    const faceListManager = new FaceListManager();
    const visitorManager = new VisitorListManager();
    const pieChartManagerfm = new PieChartManagerfm();
    const pieChartManagerbw = new PieChartManagerbw();
    const pieChartCrowded = new PieChartCrowded();
    const seriesLineCrowded = new SeriesLineCrowded();
    const seriesLineDays = new SeriesLineDays();
    const visitorCounter = new VisitorCounter();


    const wsHandler = new WebSocketHandler('ws://192.168.8.15:8765', (data) => {
        cameraManager.handleFrame(data);
    });
    
    // Clean up on page unload
    window.addEventListener('beforeunload', () => {
        if (pieChartManagerfm) {
            pieChartManagerfm.destroy();
        }
        if (pieChartManagerbw) {
            pieChartManagerbw.destroy();
        }
        if (pieChartCrowded) {
            pieChartCrowded.destroy();
        }
        if (seriesLineCrowded) {
            seriesLineCrowded.destroy();
        }
        if (seriesLineDays) {
            seriesLineDays.destroy();
        }
    });
});

