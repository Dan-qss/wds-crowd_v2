// static/js/barchart-dynamic-manager.js
export default class BarChartDynamicManager {
  constructor({
    crowdApiBase,
    canvasId = "barChart2",
    legendId = "barChart2-legend",
    updateMs = 60 * 60 * 1000,     // كل ساعة
    windowSeconds = 60 * 60,       // آخر ساعة
    yMax = null,                   // إذا بدك تثبيت السقف (مثلا 100)
  } = {}) {
    this.base = (crowdApiBase || "").replace(/\/$/, "");
    this.canvas = document.getElementById(canvasId);
    this.legendEl = document.getElementById(legendId);

    this.updateMs = updateMs;
    this.windowSeconds = windowSeconds;
    this.yMax = yMax;

    this.timer = null;

    // mock default
    this.mockZonesCount = 4;

    if (!this.canvas) {
      console.error("Bar canvas not found:", canvasId);
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
    if (!this.base) return this._applyMockData();

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

      if (!labelsRaw.length || !valuesRaw.length) return this._applyMockData();

      const labels = labelsRaw.map((z) => this._pretty(z));
      const values = valuesRaw.map((v) => Number(v) || 0);

      this._draw(labels, values);
    } catch (e) {
      this._applyMockData();
    }
  }

  _applyMockData() {
    const labels = Array.from({ length: this.mockZonesCount }, (_, i) => `Zone ${i + 1}`);
    // قيم عشوائية (مثلاً كنسب 0-100)
    const values = labels.map(() => Math.random() * 100);
    this._draw(labels, values);
  }

  _redrawLast() {
    if (this._last) this._draw(this._last.labels, this._last.values);
  }

  _draw(labels, values) {
    this._last = { labels, values };

    // resize canvas to fit box
    const w = this.canvas.clientWidth || 260;
    const h = this.canvas.clientHeight || 190;
    this.canvas.width = w;
    this.canvas.height = h;

    const ctx = this.ctx;
    ctx.clearRect(0, 0, w, h);

    // layout
    const pad = { l: 34, r: 10, t: 12, b: 26 };
    const plotW = w - pad.l - pad.r;
    const plotH = h - pad.t - pad.b;

    const colors = this._colors(labels.length);
    const maxV = this.yMax ?? Math.max(...values, 1);
    const niceMax = this._niceMax(maxV);

    // grid + y ticks
    const ticks = 4;
    ctx.strokeStyle = "rgba(255,255,255,0.10)";
    ctx.fillStyle = "rgba(255,255,255,0.70)";
    ctx.font = "11px Segoe UI, Arial";
    ctx.textAlign = "right";
    ctx.textBaseline = "middle";

    for (let i = 0; i <= ticks; i++) {
      const y = pad.t + (plotH * i) / ticks;
      ctx.beginPath();
      ctx.moveTo(pad.l, y);
      ctx.lineTo(pad.l + plotW, y);
      ctx.stroke();

      const v = niceMax * (1 - i / ticks);
      ctx.fillText(this._fmtNum(v), pad.l - 6, y);
    }

    // bars
    const n = labels.length || 1;
    const gap = Math.max(6, Math.floor(plotW * 0.03));
    const barW = Math.max(10, Math.floor((plotW - gap * (n - 1)) / n));

    ctx.textAlign = "center";
    ctx.textBaseline = "top";

    for (let i = 0; i < n; i++) {
      const x = pad.l + i * (barW + gap);
      const v = values[i] || 0;
      const barH = (Math.max(0, v) / niceMax) * plotH;
      const y = pad.t + (plotH - barH);

      // bar
      ctx.fillStyle = colors[i];
      this._roundRect(ctx, x, y, barW, barH, 6);
      ctx.fill();

      // value label فوق العمود
      ctx.fillStyle = "rgba(255,255,255,0.85)";
      ctx.font = "bold 11px Segoe UI, Arial";
      ctx.fillText(this._fmtNum(v), x + barW / 2, Math.max(pad.t, y - 14));

      // x label (مختصر)
      ctx.fillStyle = "rgba(255,255,255,0.75)";
      ctx.font = "11px Segoe UI, Arial";
      const short = this._shortLabel(labels[i], 10);
      ctx.fillText(short, x + barW / 2, pad.t + plotH + 8);
    }

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
              <span class="tabular-nums text-white/80">${v}</span>
            </div>
          `;
        })
        .join("");
    }
  }

  _roundRect(ctx, x, y, w, h, r) {
    const rr = Math.min(r, w / 2, h / 2);
    ctx.beginPath();
    ctx.moveTo(x + rr, y);
    ctx.arcTo(x + w, y, x + w, y + h, rr);
    ctx.arcTo(x + w, y + h, x, y + h, rr);
    ctx.arcTo(x, y + h, x, y, rr);
    ctx.arcTo(x, y, x + w, y, rr);
    ctx.closePath();
  }

  _niceMax(v) {
    // "nice" سقف للـY axis
    if (v <= 0) return 1;
    const pow = Math.pow(10, Math.floor(Math.log10(v)));
    const n = v / pow;
    const nice =
      n <= 1 ? 1 :
      n <= 2 ? 2 :
      n <= 5 ? 5 : 10;
    return nice * pow;
  }

  _fmtNum(v) {
    // رقم صغير بدون مبالغة
    if (!isFinite(v)) return "0";
    if (Math.abs(v) >= 100) return String(Math.round(v));
    return (Math.round(v * 10) / 10).toFixed(1);
  }

  _shortLabel(s, max = 10) {
    const str = String(s || "");
    if (str.length <= max) return str;
    return str.slice(0, max - 1) + "…";
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
