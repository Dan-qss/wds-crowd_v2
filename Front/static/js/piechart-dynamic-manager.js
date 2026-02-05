// static/js/piechart-dynamic-manager.js
export default class PieChartDynamicManager {
  constructor({
    crowdApiBase,
    canvasId = "pieChart2",
    legendId = "pieChart2-legend",
    updateMs = 8000,
    windowSeconds = 60,
  } = {}) {
    this.base = (crowdApiBase || "").replace(/\/$/, "");
    this.canvas = document.getElementById(canvasId);
    this.legendEl = document.getElementById(legendId);

    this.updateMs = updateMs;
    this.windowSeconds = windowSeconds;

    this.timer = null;

    // mock default
    this.mockZonesCount = 4;

    if (!this.canvas) {
      console.error("Pie canvas not found:", canvasId);
      return;
    }
    this.ctx = this.canvas.getContext("2d");

    window.addEventListener("resize", () => this._redrawLast());
    this._last = null;
  }

  start() {
    this.stop();
    this.updateLatestData();
    this.timer = setInterval(() => this.updateLatestData(), this.updateMs);
  }

  stop() {
    if (this.timer) clearInterval(this.timer);
    this.timer = null;
  }

  destroy() {
    this.stop();
  }

  async updateLatestData() {
    // إذا API base مش موجود أو fetch فشل → mock
    if (!this.base) {
      return this._applyMockData();
    }

    const end = new Date();
    const start = new Date(end.getTime() - this.windowSeconds * 1000);

    const url =
      `${this.base}/analysis/zone-occupancy?start_time=${encodeURIComponent(this._fmt(start))}` +
      `&end_time=${encodeURIComponent(this._fmt(end))}`;

    try {
      const res = await fetch(url);
      if (!res.ok) throw new Error(`HTTP ${res.status}`);
      const data = await res.json();

      const labelsRaw = data?.chart_data?.labels || [];
      const valuesRaw = data?.chart_data?.values || [];

      // لو الداتا فاضية كمان mock
      if (!labelsRaw.length || !valuesRaw.length) {
        return this._applyMockData();
      }

      const labels = labelsRaw.map(this._pretty);
      const values = valuesRaw.map((v) => Number(v) || 0);

      this._draw(labels, values);
    } catch (e) {
      this._applyMockData();
    }
  }

  _applyMockData() {
    const labels = Array.from({ length: this.mockZonesCount }, (_, i) => `Zone ${i + 1}`);

    // نسب مجموعها 100
    const raw = labels.map(() => Math.random());
    const sum = raw.reduce((a, b) => a + b, 0) || 1;
    const values = raw.map((v) => (v / sum) * 100);

    this._draw(labels, values);
  }

  _redrawLast() {
    if (this._last) this._draw(this._last.labels, this._last.values);
  }

  _draw(labels, values) {
    this._last = { labels, values };

    // resize canvas to fit box
    const w = this.canvas.clientWidth || 260;
    const h = this.canvas.clientHeight || 160;
    this.canvas.width = w;
    this.canvas.height = h;

    const ctx = this.ctx;
    ctx.clearRect(0, 0, w, h);

    const total = values.reduce((a, b) => a + b, 0) || 1;
    const colors = this._colors(labels.length);

    // donut geometry
    const cx = w / 2;
    const cy = h / 2;
    const rOuter = Math.min(w, h) * 0.42;
    const rInner = rOuter * 0.65;

    let angle = -Math.PI / 2; // start at top

    for (let i = 0; i < values.length; i++) {
      const slice = (values[i] / total) * Math.PI * 2;

      ctx.beginPath();
      ctx.moveTo(cx, cy);
      ctx.arc(cx, cy, rOuter, angle, angle + slice);
      ctx.closePath();
      ctx.fillStyle = colors[i];
      ctx.fill();

      angle += slice;
    }

    // inner cutout
    ctx.beginPath();
    ctx.arc(cx, cy, rInner, 0, Math.PI * 2);
    ctx.fillStyle = "rgba(0,0,0,0.35)";
    ctx.fill();

    // center text (sum should be 100 تقريبًا)
    ctx.fillStyle = "rgba(255,255,255,0.92)";
    ctx.font = "bold 14px Segoe UI, Arial";
    ctx.textAlign = "center";
    ctx.textBaseline = "middle";
    ctx.fillText("Zones", cx, cy - 9);

    ctx.fillStyle = "rgba(255,255,255,0.85)";
    ctx.font = "12px Segoe UI, Arial";
    ctx.fillText("Live", cx, cy + 10);

    // legend
    if (this.legendEl) {
      this.legendEl.innerHTML = labels
        .map((l, i) => {
          const v = Number(values[i] || 0).toFixed(1);
          return `
            <div class="flex items-center justify-between gap-3">
              <div class="flex items-center gap-2 min-w-0">
                <span style="background:${colors[i]};" class="inline-block w-3 h-3 rounded-sm shrink-0"></span>
                <span class="truncate">${l}</span>
              </div>
              <span class="tabular-nums text-white/80">${v}%</span>
            </div>
          `;
        })
        .join("");
    }
  }

  _fmt(d) {
    const pad = (n) => String(n).padStart(2, "0");
    return `${d.getFullYear()}-${pad(d.getMonth() + 1)}-${pad(d.getDate())} ${pad(d.getHours())}:${pad(
      d.getMinutes()
    )}:${pad(d.getSeconds())}`;
  }

  _pretty(z) {
    return String(z || "")
      .replace(/[-_]+/g, " ")
      .trim()
      .replace(/\b\w/g, (c) => c.toUpperCase());
  }

  _colors(n) {
    const palette = [
      "#4CAF50", "#2196F3", "#FFC107", "#9C27B0",
      "#00BCD4", "#FF5722", "#8BC34A", "#E91E63",
      "#3F51B5", "#CDDC39",
    ];
    return Array.from({ length: n }, (_, i) => palette[i % palette.length]);
  }
}
