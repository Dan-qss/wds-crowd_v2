// static/js/main.js
import { CONFIG } from "./config.js";

import WebSocketHandler from "./websocket-handler.js";
import CameraManager from "./camera-manager.js";
import FaceListManager from "./face-list-manager.js";

document.addEventListener("DOMContentLoaded", () => {
  // ---------------------------
  // 1) Live Feeds (always start)
  // ---------------------------
  const cameraManager = new CameraManager({
    box1: { canvasId: "camera1", rotateCameraIds: ["1", "2", "3"], intervalMs: 5000 },
    box2: { canvasId: "camera2", rotateCameraIds: ["4", "5"], intervalMs: 5000 },
  });

  const wsHandler = new WebSocketHandler(CONFIG.WS_URL, (data) => {
    try {
      cameraManager.handleFrame(data);
    } catch (e) {
      console.error("CameraManager.handleFrame error:", e);
    }
  });

  // ---------------------------
  // 2) Face list (always start)
  // ---------------------------
  const faceListManager = new FaceListManager({
    baseUrl: CONFIG.FACE_API_BASE,
    limit: 8,
    pollMs: 1500,
    containerSelector: ".facelist-container",
  });

  // ---------------------------
  // 3) KPI (optional) - dynamic import so it can NEVER stop the app
  // ---------------------------
  let kpis = null;

  (async () => {
    try {
      const mod = await import("./kpi-manager.js"); // ✅ if this fails, streams/face keep working
      const KPIManager = mod.default;

      kpis = new KPIManager({ crowdApiBaseUrl: CONFIG.CROWD_API_BASE });
      kpis.start(); // ✅ start() بدون باراميتر
    } catch (e) {
      console.error("KPI failed to load/start (streams & face still running):", e);
    }
  })();

  // ---------------------------
  // 4) Top Crowded Zones (optional) - dynamic import
  // ---------------------------
  let topZones = null;

  (async () => {
    try {
      const mod = await import("./top-zones-manager.js");
      const TopZonesManager = mod.default;

      topZones = new TopZonesManager({
        crowdApiBaseUrl: CONFIG.CROWD_API_BASE,
        debug: false,
        limit: 3,
        metric: "percentage", // أو "people"
      });

      topZones.start();
    } catch (e) {
      console.error("TopZones failed to load/start (app still running):", e);
    }
  })();

  // ---------------------------
  // 5) Cleanup
  // ---------------------------
  window.addEventListener("beforeunload", () => {
    try {
      wsHandler?.close?.();
    } catch {}
    try {
      cameraManager?.destroy?.();
    } catch {}
    try {
      faceListManager?.destroy?.();
    } catch {}
    try {
      kpis?.stop?.();
    } catch {}
    try {
      topZones?.stop?.();
    } catch {}
  });
});
