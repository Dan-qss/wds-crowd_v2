// static/js/top-zones-manager.js
export default class TopZonesManager {
  constructor({ crowdApiBaseUrl, debug = false, limit = 3, metric = "percentage" }) {
    this.baseUrl = crowdApiBaseUrl.replace(/\/$/, "");
    this.debug = debug;

    this.limit = limit;          // أعلى كم منطقة نعرض
    this.metric = metric;        // "percentage" أو "people"

    this.elList = document.getElementById("top-zones-list");

    this.windowMs = 5 * 60 * 1000; // آخر 5 دقائق
    this.timer = null;
  }

  start() {
    this.stop();
    this.tick();
    this.timer = setInterval(() => this.tick(), this.windowMs); // كل 5 دقائق
  }

  stop() {
    if (this.timer) clearInterval(this.timer);
    this.timer = null;
  }

  async tick() {
    if (!this.elList) return;

    try {
      const end = this.floorToMinute(new Date());
      const start = new Date(end.getTime() - this.windowMs);

      const startStr = this.formatYmdHm(start);
      const endStr = this.formatYmdHm(end);

      const url =
        `${this.baseUrl}/analysis/zone-occupancy?start_time=${encodeURIComponent(startStr)}` +
        `&end_time=${encodeURIComponent(endStr)}`;

      const resp = await this.fetchJson(url);
      const zones = Array.isArray(resp?.zone_data) ? resp.zone_data : [];

      const items = zones.map((z) => ({
        name: z.zone_name ?? "Unknown",
        pct: Number(z.avg_percentage ?? 0),
        people: Number(z.total_people ?? 0),
      }));

      // رتب حسب اللي بدك: نسبة أو عدد
      items.sort((a, b) => {
        if (this.metric === "people") return b.people - a.people;
        return b.pct - a.pct; // default percentage
      });

      const top = items.slice(0, this.limit);
      this.render(top);

      if (this.debug) console.log("[TopZones] top:", top, "range:", { startStr, endStr });
    } catch (e) {
      console.error("[TopZones] فشل:", e?.message || e);
      this.render([]);
    }
  }

  render(top) {
    this.elList.innerHTML = "";

    if (!top.length) {
      this.elList.innerHTML = `<p class="text-muted text-sm text-center">No data</p>`;
      return;
    }

    const barClassFor = (pct) => {
      if (pct >= 70) return "bg-alert-red";
      if (pct >= 40) return "bg-alert-yellow";
      return "bg-accent";
    };

    for (const z of top) {
      const pctRounded = Math.round(z.pct);
      const width = `${Math.max(0, Math.min(100, z.pct))}%`;

      const row = document.createElement("div");
      row.innerHTML = `
        <div class="flex justify-between text-sm mb-1">
          <span class="text-white">${this.escapeHtml(z.name)}</span>
          <span class="text-muted">${pctRounded}%</span>
        </div>
        <div class="h-2 rounded-full bg-card-dark overflow-hidden">
          <div class="h-full rounded-full ${barClassFor(z.pct)}" style="width: ${width};"></div>
        </div>
      `;
      this.elList.appendChild(row);
    }
  }

  // Helpers
  async fetchJson(url) {
    const res = await fetch(url);
    if (!res.ok) throw new Error(`HTTP ${res.status} - ${url}`);
    return res.json();
  }

  floorToMinute(d) {
    const x = new Date(d);
    x.setSeconds(0, 0);
    return x;
  }

  formatYmdHm(d) {
    const yyyy = d.getFullYear();
    const mm = String(d.getMonth() + 1).padStart(2, "0");
    const dd = String(d.getDate()).padStart(2, "0");
    const hh = String(d.getHours()).padStart(2, "0");
    const mi = String(d.getMinutes()).padStart(2, "0");
    return `${yyyy}-${mm}-${dd} ${hh}:${mi}`;
  }

  escapeHtml(str) {
    return String(str)
      .replaceAll("&", "&amp;")
      .replaceAll("<", "&lt;")
      .replaceAll(">", "&gt;")
      .replaceAll('"', "&quot;")
      .replaceAll("'", "&#039;");
  }
}
