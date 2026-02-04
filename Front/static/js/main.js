// static/js/main.js
import { CONFIG } from "./config.js";
import WebSocketHandler from "./websocket-handler.js";
import CameraManager from "./camera-manager.js";
import FaceListManager from "./face-list-manager.js";



document.addEventListener("DOMContentLoaded", () => {
  // Cameras
  const cameraManager = new CameraManager({
    cameraNames: CONFIG.CAMERA_NAMES,
    box1: {
      canvasId: "camera1",
      labelElId: "cam1-label",
      rotateCameraIds: ["1", "2", "3"],
      intervalMs: 5000,
    },
    box2: {
      canvasId: "camera2",
      labelElId: "cam2-label",
      rotateCameraIds: ["4", "5"],
      intervalMs: 5000,
    },
  });

  // WS frames → cameraManager
  const wsHandler = new WebSocketHandler(CONFIG.WS_URL, (data) => {
    try {
      cameraManager.handleFrame(data);
    } catch (e) {
      console.error("CameraManager.handleFrame error:", e);
    }
  });

  // KPI
  let kpis = null;
  (async () => {
    try {
      const mod = await import("./kpi-manager.js");
      const KPIManager = mod.default;
      kpis = new KPIManager({ crowdApiBaseUrl: CONFIG.CROWD_API_BASE });
      kpis.start();
    } catch (e) {
      console.error("KPI failed:", e);
    }
  })();

  // Top zones (if you added top-zones-manager.js)
  let topZones = null;
  (async () => {
    try {
      const mod = await import("./top-zones-manager.js");
      const TopZonesManager = mod.default;
      topZones = new TopZonesManager({
        crowdApiBaseUrl: CONFIG.CROWD_API_BASE,
        limit: 3,
        metric: "percentage",
      });
      topZones.start();
    } catch (e) {
      console.error("TopZones failed:", e);
    }
  })();

  // Peak line chart (Today hourly)
  let peakLine = null;
  (async () => {
    try {
      const mod = await import("./peakline-manager.js");
      const PeakLineManager = mod.default;
      peakLine = new PeakLineManager({
        crowdApiBase: CONFIG.CROWD_API_BASE,
        pollMs: CONFIG.POLL_MS?.PEAK_CHART ?? 5 * 60 * 1000,
        startHour: 8,
        endHour: 21,
      });
      peakLine.start();
    } catch (e) {
      console.error("PeakLine failed:", e);
    }
  })();

  const faceListManager = new FaceListManager({
  baseUrl: CONFIG.FACE_API_BASE,
  limit: 8,
  pollMs: 1500,
  containerSelector: ".facelist-container",
});

  // Cleanup
  window.addEventListener("beforeunload", () => {
    try { wsHandler?.close?.(); } catch {}
    try { cameraManager?.destroy?.(); } catch {}
    try { kpis?.stop?.(); } catch {}
    try { topZones?.stop?.(); } catch {}
    try { peakLine?.stop?.(); } catch {}
    try { faceListManager?.destroy?.(); } catch {}

  });
});
