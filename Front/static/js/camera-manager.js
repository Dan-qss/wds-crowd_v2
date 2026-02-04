// static/js/camera-manager.js
import * as pako from "https://cdn.jsdelivr.net/npm/pako@2.1.0/dist/pako.esm.mjs";

class CameraManager {
  constructor({ box1, box2, cameraLabels = {} }) {
    this.frames = {}; // cameraId -> last Image
    this.lastFrameTs = {}; // cameraId -> timestamp
    this.cameraLabels = cameraLabels;

    this.box1 = this._initBox(box1);
    this.box2 = this._initBox(box2);

    this._startRotation(this.box1);
    this._startRotation(this.box2);

    this._startOfflineMonitor();
    this._onResize = () => this._redrawActive();
    window.addEventListener("resize", this._onResize);
  }

  _initBox(cfg) {
    const canvas = document.getElementById(cfg.canvasId);
    if (!canvas) throw new Error(`Canvas not found: ${cfg.canvasId}`);
    const ctx = canvas.getContext("2d");

    const rotateIds = (cfg.rotateCameraIds || []).map(String);
    const activeId = rotateIds[0] || null;

    const labelEl = cfg.labelElId ? document.getElementById(cfg.labelElId) : null;

    // set initial label
    if (labelEl && activeId) labelEl.textContent = this._labelFor(activeId);

    return {
      canvas,
      ctx,
      rotateIds,
      intervalMs: cfg.intervalMs || 5000,
      idx: 0,
      timer: null,
      activeId,
      labelEl,
    };
  }

  _labelFor(cameraId) {
    const key = String(cameraId);
    const name = this.cameraLabels?.[key];
    if (name) return name;

    // fallback CAM-01 style
    const padded = key.padStart(2, "0");
    return `CAM-${padded}`;
  }

  _setActive(box, cameraId) {
    box.activeId = cameraId;
    if (box.labelEl && cameraId) box.labelEl.textContent = this._labelFor(cameraId);
  }

  _startRotation(box) {
    // draw first if available
    this._drawIfAvailable(box, box.activeId);

    box.timer = setInterval(() => {
      if (!box.rotateIds.length) return;
      box.idx = (box.idx + 1) % box.rotateIds.length;
      const nextId = box.rotateIds[box.idx];
      this._setActive(box, nextId);
      this._drawIfAvailable(box, nextId);
    }, box.intervalMs);
  }

  _startOfflineMonitor() {
    this.monitorTimer = setInterval(() => {
      const now = Date.now();
      [this.box1, this.box2].forEach((box) => {
        const id = box.activeId;
        const last = this.lastFrameTs[id] || 0;
        if (id && now - last > 10000) {
          this._showNoStream(box, id);
        }
      });
    }, 5000);
  }

  destroy() {
    clearInterval(this.box1?.timer);
    clearInterval(this.box2?.timer);
    clearInterval(this.monitorTimer);
    window.removeEventListener("resize", this._onResize);
  }

  handleFrame(data) {
    const cameraId = String(data.camera_id);
    this.lastFrameTs[cameraId] = Date.now();

    const img = new Image();
    try {
      const compressedData = atob(data.frame);
      const compressedArray = Uint8Array.from(compressedData, (c) => c.charCodeAt(0));
      const decompressedArray = pako.inflate(compressedArray);

      const blob = new Blob([decompressedArray], { type: "image/jpeg" });
      const url = URL.createObjectURL(blob);

      img.onload = () => {
        this.frames[cameraId] = img;
        URL.revokeObjectURL(url);

        if (cameraId === this.box1.activeId) this._draw(this.box1, img);
        if (cameraId === this.box2.activeId) this._draw(this.box2, img);
      };
      img.src = url;
    } catch (e) {
      console.error("Failed to decode frame", e);
    }
  }

  _drawIfAvailable(box, cameraId) {
    const img = this.frames[cameraId];
    if (img) this._draw(box, img);
    else this._showNoStream(box, cameraId);
  }

  _redrawActive() {
    if (this.box1?.activeId) this._drawIfAvailable(this.box1, this.box1.activeId);
    if (this.box2?.activeId) this._drawIfAvailable(this.box2, this.box2.activeId);
  }

  _draw(box, img) {
    const canvas = box.canvas;
    const ctx = box.ctx;

    const minW = 640;
    const minH = 360;

    const cw = Math.max(canvas.clientWidth || minW, minW);
    const ch = Math.max(canvas.clientHeight || minH, minH);

    const containerAspect = cw / ch;
    const imageAspect = img.width / img.height;

    let drawW = cw;
    let drawH = ch;

    if (containerAspect > imageAspect) drawW = drawH * imageAspect;
    else drawH = drawW / imageAspect;

    canvas.width = Math.floor(drawW);
    canvas.height = Math.floor(drawH);

    ctx.clearRect(0, 0, canvas.width, canvas.height);
    ctx.drawImage(img, 0, 0, canvas.width, canvas.height);
  }

  _showNoStream(box, cameraId) {
    const canvas = box.canvas;
    const ctx = box.ctx;

    if (canvas.width === 0) canvas.width = 640;
    if (canvas.height === 0) canvas.height = 360;

    ctx.clearRect(0, 0, canvas.width, canvas.height);
    ctx.fillStyle = "rgba(0, 0, 0, 0.7)";
    ctx.fillRect(0, 0, canvas.width, canvas.height);

    ctx.font = "bold 34px Arial";
    ctx.textAlign = "center";
    ctx.textBaseline = "middle";

    ctx.fillStyle = "rgba(0, 0, 0, 0.8)";
    ctx.fillText("NO STREAM", canvas.width / 2 + 2, canvas.height / 2 + 2);

    ctx.fillStyle = "#FF0000";
    ctx.fillText("NO STREAM", canvas.width / 2, canvas.height / 2);

    ctx.font = "16px Arial";
    ctx.fillStyle = "#FFFFFF";
    ctx.fillText(`Camera ${cameraId} offline`, canvas.width / 2, canvas.height / 2 + 40);
  }
}

export default CameraManager;
