// static/js/main.js
import { CONFIG } from "./config.js";
import WebSocketHandler from "./websocket-handler.js";
import CameraManager from "./camera-manager.js";
import FaceListManager from "./face-list-manager.js";
import ZoneMasksManager from "./zone-masks-manager.js";
import "./heatmap-manager.js"; // side-effect فقط

document.addEventListener("DOMContentLoaded", () => {
  // =========================
  // Cameras
  // =========================
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

  // =========================
  // LIVE ZONE HEATMAP (from WS) buffers
  // =========================
  const ZONE_IDS = ["1", "2", "3", "4", "5"];
  const zoneLevelBuffers = {
    "1": [],
    "2": [],
    "3": [],
    "4": [],
    "5": [],
  };

  const BATCH_SIZE = 11;
  const FLUSH_MS = 5000;

  function mode(arr) {
    const freq = {};
    let best = null,
      bestN = 0;
    for (const v of arr) {
      if (!v) continue;
      freq[v] = (freq[v] || 0) + 1;
      if (freq[v] > bestN) {
        bestN = freq[v];
        best = v;
      }
    }
    return best;
  }

  function colorForLevel(level) {
    // "Low" | "Moderate" | "Crowded"
    if (level === "Crowded") return "rgba(239, 68, 68, 0.35)";
    if (level === "Moderate") return "rgba(234, 179, 8, 0.35)";
    return "rgba(34, 197, 94, 0.28)";
  }

  // =========================
  // WS frames → cameraManager + buffers
  // =========================
  const wsHandler = new WebSocketHandler(CONFIG.WS_URL, (data) => {
    try {
      cameraManager.handleFrame(data);

      // push crowding_level into buffer for zones
      const zid = String(data.camera_id);
      const lvl = data?.status?.crowding_level || data?.crowding_level;
      if (zoneLevelBuffers[zid]) {
        zoneLevelBuffers[zid].push(lvl);
        if (zoneLevelBuffers[zid].length > BATCH_SIZE) zoneLevelBuffers[zid].shift();
      }
    } catch (e) {
      console.error("CameraManager.handleFrame error:", e);
    }
  });

  // =========================
  // KPI
  // =========================
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

  // =========================
  // Top zones
  // =========================
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

  // =========================
  // Peak line chart (Today hourly)
  // =========================
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

  // =========================
  // Face list
  // =========================
  const faceListManager = new FaceListManager({
    baseUrl: CONFIG.FACE_API_BASE,
    limit: 8,
    pollMs: 1500,
    containerSelector: ".facelist-container",
  });

  // =========================
  // Zone masks overlay
  // =========================
  let zoneMasks = null;
  (async () => {
    try {
      zoneMasks = new ZoneMasksManager({
        regionsJsonUrl: "../static/img/regions.json",
        fill: "rgba(0,0,0,0)",
      });
      await zoneMasks.start();
    } catch (e) {
      console.error("ZoneMasksManager failed:", e);
    }
  })();

  // Flush buffer → color zones كل 5 ثواني
  const heatFlushTimer = setInterval(() => {
    if (!zoneMasks) return;

    for (const zid of ZONE_IDS) {
      const buf = zoneLevelBuffers[zid];
      if (!buf?.length) continue;

      const m = mode(buf);
      if (!m) continue;

      zoneMasks.setZoneColor(zid, colorForLevel(m));
      zoneLevelBuffers[zid] = [];
    }
  }, FLUSH_MS);

  // =========================
  // TEMP demo heatmap animation (if your HeatmapManager is demoing)
  // =========================
  // const demoHeat = new window.HeatmapManager("heatmap-container");
  // const levels = ["low", "moderate", "high"];
  // let t = 0;

  // const demoHeatTimer = setInterval(() => {
  //   demoHeat.update([
  //     { x: 0.18, y: 0.55, r: 0.28, level: levels[(t + 2) % 3] },
  //     { x: 0.5, y: 0.62, r: 0.22, level: levels[(t + 1) % 3] },
  //     { x: 0.78, y: 0.35, r: 0.26, level: levels[t % 3] },
  //   ]);
  //   t++;
  // }, 3000);

  // =========================
  // Pie chart (zone distribution) - local canvas (no Chart.js)
  // =========================
  let pieChart = null;
  (async () => {
    try {
      const mod = await import("./piechart-dynamic-manager.js");
      const PieChartDynamicManager = mod.default;

      pieChart = new PieChartDynamicManager({
        crowdApiBase: CONFIG.CROWD_API_BASE, // لوكل: http://127.0.0.1:8010
        canvasId: "pieChart2",
        legendId: "pieChart2-legend",
        updateMs: 2000,
        windowSeconds: 60,
      });

      pieChart.start();
    } catch (e) {
      console.error("PieChart failed:", e);
    }
  })();

  // =========================
  // Cleanup
  // =========================
  window.addEventListener("beforeunload", () => {
    try {
      wsHandler?.close?.();
    } catch {}
    try {
      cameraManager?.destroy?.();
    } catch {}
    try {
      kpis?.stop?.();
    } catch {}
    try {
      topZones?.stop?.();
    } catch {}
    try {
      peakLine?.stop?.();
    } catch {}
    try {
      faceListManager?.destroy?.();
    } catch {}
    try {
      zoneMasks?.destroy?.();
    } catch {}
    try {
      pieChart?.destroy?.();
    } catch {}
    try {
      clearInterval(heatFlushTimer);
    } catch {}
    try {
      clearInterval(demoHeatTimer);
    } catch {}
  });
});
