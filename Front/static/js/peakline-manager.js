// static/js/peakline-manager.js
export default class PeakLineManager {
  constructor({
    crowdApiBase,
    pollMs = 5 * 60 * 1000, // كل 5 دقائق نتحقق إذا دخلنا ساعة جديدة
    startHour = 8,
    endHour = 17, // 5pm
    debug = false,
    yTickStep = 10,        // 10 أو 20
    xTickEvery = 1,        // 1 = كل ساعة (9 10 11 ..) | 2 = كل ساعتين (9 11 1 3 5)
     mockOnce = false, // NEW
  } = {}) {
    this.base = (crowdApiBase || "").replace(/\/$/, "");
    this.pollMs = pollMs;
    this.startHour = startHour;
    this.endHour = endHour;
    this.debug = debug;

    this.canvas = document.getElementById("peak-chart");
    this.ctx = this.canvas ? this.canvas.getContext("2d") : null;

    this.yTickStep = yTickStep;
    this.xTickEvery = xTickEvery;
    this.mockOnce = mockOnce;
    this.timer = null;
    this.lastBuiltForDate = null;
    this.lastCompletedHour = null; // آخر ساعة مكتملة رسمناها

    if (!this.canvas || !this.ctx || !this.base) return;

    window.addEventListener("resize", () => this._redrawLast());
  }


  start() {
    this.stop();

  if (this.mockOnce) {
    const labels = ["9", "10", "11", "12", "1", "2", "3", "4", "5"];
    const values = [62, 66, 67, 65, 84, 85, 90, 89, 86];

    this._last = { labels, values };
    this.draw(labels, values);

    // Do NOT start polling in mock mode (keeps it fixed)
    return;
  }

  this.refresh(true);
  this.timer = setInterval(() => this.refresh(false), this.pollMs);
  }

  stop() {
    if (this.timer) clearInterval(this.timer);
    this.timer = null;
  }

  async refresh(force = false) {
    if (!this.canvas || !this.ctx) return;

    const now = new Date();
    const todayKey = this._dateKey(now);

    // Reset يوم جديد
    if (this.lastBuiltForDate !== todayKey) {
      this.lastBuiltForDate = todayKey;
      this.lastCompletedHour = null;
      force = true;
    }

    // آخر ساعة “مكتملة” نقدر نحسبها: من (h-1 → h)
    const completedHour = Math.min(now.getHours(), this.endHour);
    // قبل 08:00 ما في بيانات
    if (completedHour <= this.startHour) {
      this._last = { labels: [], values: [] };
      this.draw([], []);
      return;
    }

    // إذا ما تغيرت الساعة وما في force، ما نعيد الحساب
    if (!force && this.lastCompletedHour === completedHour) return;

    // ابنِ السلسلة من 09 إلى completedHour (لأن كل نقطة = متوسط ساعة كاملة قبلها)
    const labels = [];
    const values = [];

    for (let h = this.startHour + 1; h <= completedHour; h++) {
      const start = this._todayAtHour(now, h - 1);
      const end = this._todayAtHour(now, h);

      const pct = await this._fetchAvgPctAcrossAllZones(start, end);
      labels.push(this._hourLabel(h));
      values.push(pct);
    }

    this.lastCompletedHour = completedHour;
    this._last = { labels, values };
    this.draw(labels, values);

    if (this.debug) console.log("[PeakLine] updated up to hour:", completedHour, { labels, values });
  }

  async _fetchAvgPctAcrossAllZones(startDate, endDate) {
    const startStr = this._formatYmdHm(startDate);
    const endStr = this._formatYmdHm(endDate);

    const url =
      `${this.base}/analysis/zone-occupancy?start_time=${encodeURIComponent(startStr)}` +
      `&end_time=${encodeURIComponent(endStr)}`;

    try {
      const resp = await this._fetchJson(url);
      const zones = Array.isArray(resp?.zone_data) ? resp.zone_data : [];

      if (!zones.length) return 0;

      const sumPeople = zones.reduce((s, z) => s + Number(z.total_people || 0), 0);
      const sumCap = zones.reduce((s, z) => s + Number(z.total_capacity || 0), 0);
      const pct = sumCap > 0 ? (sumPeople / sumCap) * 100 : 0;

      // clamp 0..100
      return Math.max(0, Math.min(100, pct));
    } catch (e) {
      console.error("[PeakLine] fetch failed:", e?.message || e);
      return 0;
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
    const h = canvas.clientHeight || 140;
    canvas.width = w;
    canvas.height = h;

    ctx.clearRect(0, 0, w, h);

    if (!values || values.length < 2) {
      ctx.fillStyle = "rgba(255,255,255,0.7)";
      ctx.font = "12px Inter, Arial";
      ctx.textAlign = "center";
      ctx.fillText("No data yet", w / 2, h / 2);
      return;
    }

    // Padding (left أكبر عشان أرقام الـ Y)
    const padL = 36;
    const padR = 12;
    const padT = 12;
    const padB = 22;

    const plotW = w - padL - padR;
    const plotH = h - padT - padB;

    const xForIndex = (i) => padL + (plotW * i) / (values.length - 1);
    const yForValue = (v) => {
      const t = Math.max(0, Math.min(100, v)) / 100; // clamp 0..1
      return padT + (1 - t) * plotH;
    };

    // ===== Grid + Y ticks =====
    const step = this.yTickStep || 10; // 10 أو 20
    ctx.lineWidth = 1;
    ctx.font = "10px Inter, Arial";
    ctx.textAlign = "right";
    ctx.textBaseline = "middle";

    for (let yv = 0; yv <= 100; yv += step) {
      const y = yForValue(yv);

      // grid line
      ctx.strokeStyle = "rgba(255,255,255,0.08)";
      ctx.beginPath();
      ctx.moveTo(padL, y);
      ctx.lineTo(w - padR, y);
      ctx.stroke();

      // y label
      ctx.fillStyle = "rgba(226,232,240,0.65)";
      ctx.fillText(`${yv}%`, padL - 6, y);
    }

    // ===== Axes =====
    ctx.strokeStyle = "rgba(255,255,255,0.25)";
    ctx.lineWidth = 1.2;

    // Y axis
    ctx.beginPath();
    ctx.moveTo(padL, padT);
    ctx.lineTo(padL, h - padB);
    ctx.stroke();

    // X axis
    ctx.beginPath();
    ctx.moveTo(padL, h - padB);
    ctx.lineTo(w - padR, h - padB);
    ctx.stroke();

    // ===== Line =====
    ctx.strokeStyle = "rgba(34,197,94,1)";
    ctx.lineWidth = 2;
    ctx.beginPath();
    ctx.moveTo(xForIndex(0), yForValue(values[0]));
    for (let i = 1; i < values.length; i++) {
      ctx.lineTo(xForIndex(i), yForValue(values[i]));
    }
    ctx.stroke();

    // ===== Points =====
    ctx.fillStyle = "rgba(34,197,94,1)";
    for (let i = 0; i < values.length; i++) {
      const x = xForIndex(i);
      const y = yForValue(values[i]);
      ctx.beginPath();
      ctx.arc(x, y, 3, 0, Math.PI * 2);
      ctx.fill();
    }

    // ===== X labels =====
    ctx.fillStyle = "rgba(148,163,184,0.95)";
    ctx.font = "10px Inter, Arial";
    ctx.textAlign = "center";
    ctx.textBaseline = "top";

    const every = this.xTickEvery || 1; // 1 أو 2
    for (let i = 0; i < labels.length; i++) {
      const show = (i % every === 0) || (i === labels.length - 1);
      if (!show) continue;

      const x = xForIndex(i);

      // tick mark
      ctx.strokeStyle = "rgba(255,255,255,0.18)";
      ctx.lineWidth = 1;
      ctx.beginPath();
      ctx.moveTo(x, h - padB);
      ctx.lineTo(x, h - padB + 4);
      ctx.stroke();

      // label
      ctx.fillText(labels[i], x, h - padB + 6);
    }
  }


  async _fetchJson(url) {
    const res = await fetch(url);
    if (!res.ok) throw new Error(`HTTP ${res.status} - ${url}`);
    return res.json();
  }

  _todayAtHour(now, hour) {
    const d = new Date(now);
    d.setHours(hour, 0, 0, 0);
    return d;
  }

  _formatYmdHm(d) {
    const yyyy = d.getFullYear();
    const mm = String(d.getMonth() + 1).padStart(2, "0");
    const dd = String(d.getDate()).padStart(2, "0");
    const hh = String(d.getHours()).padStart(2, "0");
    const mi = String(d.getMinutes()).padStart(2, "0");
    return `${yyyy}-${mm}-${dd} ${hh}:${mi}`;
  }

  _hourLabel(h) {
  const hh = h % 12 === 0 ? 12 : h % 12;
    return String(hh); 
 }

  _dateKey(d) {
    return `${d.getFullYear()}-${d.getMonth() + 1}-${d.getDate()}`;
  }
}
