// static/js/peakline-manager.js
import { fetchJson, clampPct, hourLabelFromIso } from './utils.js';

export default class PeakLineManager {
  constructor({ crowdApiBase, pollMs = 15000 } = {}) {
    this.base = crowdApiBase;
    this.pollMs = pollMs;
    this.zone = null;

    this.canvas = document.getElementById('peak-chart');
    this.ctx = this.canvas ? this.canvas.getContext('2d') : null;

    this.timer = null;
    this.abort = null;

    if (!this.canvas || !this.ctx) return;

    // لما KPI يحدد Top Zone، خذها وارسم فوراً
    window.addEventListener('topzone:change', (e) => {
      const z = e?.detail?.zone;
      if (z && z !== this.zone) {
        this.zone = z;
        this.refresh();
      }
    });

    window.addEventListener('resize', () => this._redrawLast());
    this.timer = setInterval(() => this.refresh(), this.pollMs);
  }

  destroy() {
    if (this.timer) clearInterval(this.timer);
    this.timer = null;
    if (this.abort) this.abort.abort();
    this.abort = null;
  }

  async refresh() {
    if (!this.base || !this.zone || !this.canvas || !this.ctx) return;

    if (this.abort) this.abort.abort();
    this.abort = new AbortController();

    try {
      const url = `${this.base}/zones/${encodeURIComponent(this.zone)}/hourly-averages`;
      const data = await fetchJson(url, { signal: this.abort.signal });

      const labels = (data || []).map(x => hourLabelFromIso(x.hour));
      const values = (data || []).map(x => clampPct(x.avg_percentage));

      this._last = { labels, values };
      this.draw(labels, values);

      // KPI Peak Time (اختياري)
      const peakIdx = values.length ? values.indexOf(Math.max(...values)) : -1;
      const peakEl = document.getElementById('kpi-peak-time');
      if (peakEl && peakIdx >= 0) peakEl.textContent = labels[peakIdx] || '--';

    } catch (e) {
      console.error('[PeakLineManager]', e);
      // لا تعمل throw عشان ما توقف شيء
    }
  }

  _redrawLast() {
    if (this._last) this.draw(this._last.labels, this._last.values);
  }

  draw(labels, values) {
    const canvas = this.canvas;
    const ctx = this.ctx;

    // match css size
    const w = canvas.clientWidth || 300;
    const h = canvas.clientHeight || 120;
    canvas.width = w;
    canvas.height = h;

    ctx.clearRect(0, 0, w, h);

    if (!values || values.length < 2) {
      ctx.fillStyle = 'rgba(255,255,255,0.7)';
      ctx.font = '12px Inter, Arial';
      ctx.textAlign = 'center';
      ctx.fillText('No data', w / 2, h / 2);
      return;
    }

    const padding = 10;
    const plotW = w - padding * 2;
    const plotH = h - padding * 2 - 14; // space for x labels

    // Normalize
    const maxV = 100;
    const minV = 0;

    const xStep = plotW / (values.length - 1);

    const yFor = (v) => {
      const t = (v - minV) / (maxV - minV);
      return padding + (1 - t) * plotH;
    };

    // Area fill
    ctx.beginPath();
    ctx.moveTo(padding, yFor(values[0]));
    for (let i = 1; i < values.length; i++) {
      ctx.lineTo(padding + i * xStep, yFor(values[i]));
    }
    ctx.lineTo(padding + plotW, padding + plotH);
    ctx.lineTo(padding, padding + plotH);
    ctx.closePath();

    const grad = ctx.createLinearGradient(0, padding, 0, padding + plotH);
    grad.addColorStop(0, 'rgba(34,197,94,0.35)');
    grad.addColorStop(1, 'rgba(34,197,94,0)');
    ctx.fillStyle = grad;
    ctx.fill();

    // Line
    ctx.beginPath();
    ctx.moveTo(padding, yFor(values[0]));
    for (let i = 1; i < values.length; i++) {
      ctx.lineTo(padding + i * xStep, yFor(values[i]));
    }
    ctx.strokeStyle = 'rgba(34,197,94,1)';
    ctx.lineWidth = 2;
    ctx.stroke();

    // X labels (few)
    ctx.fillStyle = 'rgba(148,163,184,1)';
    ctx.font = '10px Inter, Arial';
    ctx.textAlign = 'center';
    const ticks = 4;
    for (let i = 0; i < ticks; i++) {
      const idx = Math.round((i / (ticks - 1)) * (labels.length - 1));
      const x = padding + idx * xStep;
      ctx.fillText(labels[idx] || '', x, h - 2);
    }
  }
}
