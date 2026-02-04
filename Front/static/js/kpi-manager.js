// static/js/kpi-manager.js
export default class KPIManager {
  constructor({ crowdApiBaseUrl, debug = false }) {
    this.baseUrl = crowdApiBaseUrl.replace(/\/$/, "");
    this.debug = debug;

    // مؤقتات التحديث
    this.totalTimer = null; // كل دقيقة
    this.zoneTimer = null;  // كل دقيقة (zone)
    this.occTimer = null;   // كل 5 دقائق (Avg last 5 min)

    // عناصر الواجهة
    this.elTotal = document.getElementById("kpi-total");
    this.elZone = document.getElementById("kpi-zone");
    this.elOccupancy = document.getElementById("kpi-occupancy");

    // السطر اللي تحت Current Total (إذا بدك تحطيه JS بدل HTML)
    this.totalTrendLine = this.findTrendLineAfter(this.elTotal);

    // السطر اللي تحت Average Occupancy
    this.occTrendLine = this.findTrendLineAfter(this.elOccupancy);

    // إعدادات Average Occupancy (آخر 5 دقائق)
    this.occWindowMs = 5 * 60 * 1000; // 5 دقائق
  }

  start() {
    this.stop();

    // 1) Current Total كل دقيقة
    this.tickTotal();
    this.totalTimer = setInterval(() => this.tickTotal(), 60 * 1000);

    // 2) Most Crowded Zone كل دقيقة
    this.tickZone();
    this.zoneTimer = setInterval(() => this.tickZone(), 60 * 1000);

    // 3) Average Occupancy (آخر 5 دقائق) من DB - تحديث كل 5 دقائق
    this.tickOccupancyLast5Min();
    this.occTimer = setInterval(() => this.tickOccupancyLast5Min(), this.occWindowMs);
  }

  stop() {
    if (this.totalTimer) clearInterval(this.totalTimer);
    if (this.zoneTimer) clearInterval(this.zoneTimer);
    if (this.occTimer) clearInterval(this.occTimer);

    this.totalTimer = null;
    this.zoneTimer = null;
    this.occTimer = null;
  }

  // -------------------------
  // Current Total (كل دقيقة)
  // -------------------------
  async tickTotal() {
    try {
      const summary = await this.fetchJson(`${this.baseUrl}/occupancy/summary`);
      const totalPeople = Number(summary?.total_people || 0);

      if (this.elTotal) this.elTotal.textContent = totalPeople.toLocaleString();

      // إذا بدك تفرض النص من JS بدل HTML:
      // this.setTrendTextOnly(this.totalTrendLine, "Live - Across all monitored zones");

      if (this.debug) console.log("[KPI] total_people:", totalPeople);
    } catch (e) {
      console.error("[KPI] Current Total فشل:", e?.message || e);
    }
  }

  // ----------------------------------------
  // Most Crowded Zone (كل دقيقة)
  // ----------------------------------------
  async tickZone() {
    try {
      const current = await this.fetchJson(`${this.baseUrl}/occupancy/current`);
      const top = this.computeTopZone(current);

      if (top?.zone && this.elZone) this.elZone.textContent = top.zone;

      if (this.debug) console.log("[KPI] top_zone:", top);
    } catch (e) {
      console.error("[KPI] Most Crowded Zone فشل:", e?.message || e);
    }
  }

  // --------------------------------------------
  // Average Occupancy (آخر 5 دقائق) من DB
  // يعتمد على API: /analysis/zone-occupancy?start_time=...&end_time=...
  // --------------------------------------------
  async tickOccupancyLast5Min() {
    if (!this.elOccupancy) return;

    try {
      const end = this.floorToMinute(new Date()); // الدقيقة الحالية (00 ثانية)
      const start = new Date(end.getTime() - this.occWindowMs);

      const startStr = this.formatYmdHm(start);
      const endStr = this.formatYmdHm(end);

      const url =
        `${this.baseUrl}/analysis/zone-occupancy?start_time=${encodeURIComponent(startStr)}` +
        `&end_time=${encodeURIComponent(endStr)}`;

      const resp = await this.fetchJson(url);
      const zones = Array.isArray(resp?.zone_data) ? resp.zone_data : [];

      if (!zones.length) {
        this.elOccupancy.textContent = "0%";
        this.setTrendTextOnly(this.occTrendLine, "Avg (last 5 min)");
        return;
      }

      const sumPeople = zones.reduce((s, z) => s + Number(z.total_people || 0), 0);
      const sumCap = zones.reduce((s, z) => s + Number(z.total_capacity || 0), 0);

      const avgPct = sumCap > 0 ? (sumPeople / sumCap) * 100 : 0;

      this.elOccupancy.textContent = `${Math.round(avgPct)}%`;
      this.setTrendTextOnly(this.occTrendLine, "Avg (last 5 min)");

      if (this.debug) {
        console.log("[KPI] occupancy_last5m:", Math.round(avgPct), "%", {
          start: startStr,
          end: endStr,
          zones: zones.length,
        });
      }
    } catch (e) {
      console.error("[KPI] Occupancy آخر 5 دقائق فشل:", e?.message || e);
      this.elOccupancy.textContent = "--%";
      this.setTrendTextOnly(this.occTrendLine, "Avg (last 5 min)");
    }
  }

  // -------------------------
  // حساب أكثر Zone ازدحامًا
  // -------------------------
  computeTopZone(measurements) {
    if (!Array.isArray(measurements) || measurements.length === 0) return null;

    let best = null;

    for (const m of measurements) {
      const zone = m.zone_name || "Unknown";
      const ppl = Number(m.number_of_people || 0);
      const cap = Number(m.capacity || 0);
      const pct = cap > 0 ? (ppl / cap) * 100 : 0;

      if (!best || pct > best.pct) best = { zone, pct, ppl, cap };
    }

    return best;
  }

  // -------------------------
  // أدوات DOM بسيطة
  // -------------------------
  findTrendLineAfter(valueEl) {
    if (!valueEl) return null;
    const card = valueEl.closest(".rounded-xl");
    if (!card) return null;

    const ps = Array.from(card.querySelectorAll("p"));
    const idx = ps.findIndex((p) => p.contains(valueEl));
    return idx >= 0 ? ps[idx + 1] || null : null;
  }

  setTrendTextOnly(lineEl, text) {
    if (!lineEl) return;
    lineEl.textContent = text;
    lineEl.classList.remove("text-alert-red");
    lineEl.classList.add("text-accent");
  }

  // -------------------------
  // Helpers
  // -------------------------
  async fetchJson(url) {
    const res = await fetch(url);
    if (!res.ok) throw new Error(`HTTP ${res.status} - ${url}`);
    return res.json();
  }

  // تقطيع الوقت لأول دقيقة (ثواني وميلي ثانية = 0)
  floorToMinute(d) {
    const x = new Date(d);
    x.setSeconds(0, 0);
    return x;
  }

  // صيغة API: "YYYY-MM-DD HH:MM"
  formatYmdHm(d) {
    const yyyy = d.getFullYear();
    const mm = String(d.getMonth() + 1).padStart(2, "0");
    const dd = String(d.getDate()).padStart(2, "0");
    const hh = String(d.getHours()).padStart(2, "0");
    const mi = String(d.getMinutes()).padStart(2, "0");
    return `${yyyy}-${mm}-${dd} ${hh}:${mi}`;
  }
}
