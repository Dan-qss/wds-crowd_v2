// static/js/main.js
import { CONFIG } from "./config.js";
import WebSocketHandler from "./websocket-handler.js";
import CameraManager from "./camera-manager.js";
import FaceListManager from "./face-list-manager.js";
import ZoneMasksManager from "./zone-masks-manager.js";
import "./heatmap-manager.js"; // side-effect فقط (إذا بدك البقع)
import "./export-manager.js";
import "./date-range-manager.js";

document.addEventListener("DOMContentLoaded", () => {
  // =========================
  // Cameras
  // =========================
  const cameraManager = new CameraManager({
    cameraNames: CONFIG.CAMERA_NAMES,
    box1: {
      canvasId: "camera1",
      labelElId: "cam1-label",
      rotateCameraIds: ["1", "4", "5"],
      intervalMs: 5000,
    },
    box2: {
      canvasId: "camera2",
      labelElId: "cam2-label",
      rotateCameraIds: ["2", "3"],
      intervalMs: 5000,
    },
  });

  // ============================================================
  // ✅ IMPORTANT: regions.json has ONLY zone ids 1..5
  // ============================================================
  const ZONE_IDS = ["1", "2", "3", "4", "5"];

  // اربطي كل كاميرا بالماسك الصحيح (من 1..5)
  // 🔧 عدّلي الأرقام حسب ضغطك على الخريطة (zone click debug)
  const CAMERA_TO_MASK = {
    "1": "4", // camera 1 -> Control Center 
    "2": "5", // camera 2 -> 911
    "3": "2", // camera 3 -> Drones
    "4": "3", // camera 4 -> Barista Robot
    "5": "1", // camera 5 -> Greyshark mask
  };

  // =========================
  // Buffers
  // =========================
  const zoneLevelBuffers = Object.fromEntries(ZONE_IDS.map((z) => [z, []]));

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
    // expected values from backend: "Low" | "Moderate" | "Crowded"
    if (level === "Crowded") return "rgba(239, 68, 68, 0.35)";
    if (level === "Moderate") return "rgba(234, 179, 8, 0.35)";
    return "rgba(34, 197, 94, 0.28)";
  }

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

  // =========================
  // WS frames → cameraManager + buffers
  // =========================
  const wsHandler = new WebSocketHandler(CONFIG.WS_URL, (data) => {
    try {
      cameraManager.handleFrame(data);

      const camId = String(data.camera_id);

      // ✅ map camera -> mask zone (1..5)
      const zid = CAMERA_TO_MASK[camId];
      if (!zid) return;

      const lvl = data?.status?.crowding_level || data?.crowding_level;

      if (zoneLevelBuffers[zid]) {
        zoneLevelBuffers[zid].push(lvl);
        if (zoneLevelBuffers[zid].length > BATCH_SIZE) zoneLevelBuffers[zid].shift();
      }
    } catch (e) {
      console.error("WS callback error:", e);
    }
  });

  // =========================
  // Flush buffer → color zones
  // =========================
  const zoneLevelFlushTimer = setInterval(() => {
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
        limit: 5,
        metric: "percentage",
      });
      topZones.start();
    } catch (e) {
      console.error("TopZones failed:", e);
    }
  })();

  // =========================
  // Peak line chart
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
        endHour: 17,
        xTickEvery: 1,
        yTickStep: 10,
        mockOnce: true,
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
  // Export Manager
  // =========================
  const exportManager = new window.ExportManager("export-btn", CONFIG.CROWD_API_BASE);
  exportManager.attach();

  // =========================
  // Date Range Manager
  // =========================
  new window.DateRangeManager({
    triggerId: "date-range-trigger",
    pickerId: "date-range-picker",
    displayId: "date-range-display",
    fromId: "date-from",
    toId: "date-to",
    applyId: "date-range-apply",
    onApply: ({ from, to }) => console.log("Selected range:", from, to),
  });

  // =========================
  // Cleanup
  // =========================
  window.addEventListener("beforeunload", () => {
    try { wsHandler?.close?.(); } catch {}
    try { cameraManager?.destroy?.(); } catch {}
    try { kpis?.stop?.(); } catch {}
    try { topZones?.stop?.(); } catch {}
    try { peakLine?.stop?.(); } catch {}
    try { faceListManager?.destroy?.(); } catch {}
    try { zoneMasks?.destroy?.(); } catch {}
    try { clearInterval(zoneLevelFlushTimer); } catch {}
  });
});
