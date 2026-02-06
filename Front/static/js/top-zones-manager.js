// static/js/top-zones-manager.js
export default class TopZonesManager {
  constructor({
    crowdApiBaseUrl,
    debug = false,
    limit = 5,
    metric = "percentage",
    pollMs = 5 * 60 * 1000,     // Check periodically (e.g., every 5 minutes)
    windowMs = 60 * 60 * 1000,  // Aggregate over the last full hour
  }) {
    this.baseUrl = (crowdApiBaseUrl || "").replace(/\/$/, "");
    this.debug = debug;

    this.limit = limit;    // How many top zones to show
    this.metric = metric;  // "percentage" or "people"

    this.elList = document.getElementById("top-zones-list");

    this.pollMs = pollMs;
    this.windowMs = windowMs;

    this.timer = null;

    // Used to avoid re-fetching within the same completed hour bucket
    this.lastCompletedHourKey = null;
  }

  start() {
    this.stop();
    this.tick(true);
    this.timer = setInterval(() => this.tick(false), this.pollMs);
  }

  stop() {
    if (this.timer) clearInterval(this.timer);
    this.timer = null;
  }

  async tick(force = false) {
    if (!this.elList || !this.baseUrl) return;

    try {
      const now = new Date();

      // "End" is the top of the current hour (e.g., 14:00:00).
      // That means the last completed hour is [13:00, 14:00).
      const end = this.floorToHour(now);
      const start = new Date(end.getTime() - this.windowMs);

      // Build a stable key for the completed hour bucket
      const hourKey = this.hourKey(end);
      if (!force && this.lastCompletedHourKey === hourKey) return;
      this.lastCompletedHourKey = hourKey;

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

      // Sort by selected metric
      items.sort((a, b) => {
        if (this.metric === "people") return b.people - a.people;
        return b.pct - a.pct; // default: percentage
      });

      const top = items.slice(0, this.limit);
      this.render(top);

      if (this.debug) {
        console.log("[TopZones] updated (hour bucket):", { startStr, endStr, top });
      }
    } catch (e) {
      console.error("[TopZones] failed:", e?.message || e);
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

  // -------------------------
  // Helpers
  // -------------------------

  async fetchJson(url) {
    const res = await fetch(url);
    if (!res.ok) throw new Error(`HTTP ${res.status} - ${url}`);
    return res.json();
  }

  floorToHour(d) {
    const x = new Date(d);
    x.setMinutes(0, 0, 0);
    return x;
  }

  hourKey(d) {
    // Key based on the hour boundary (end time), e.g., "2026-2-6-14"
    return `${d.getFullYear()}-${d.getMonth() + 1}-${d.getDate()}-${d.getHours()}`;
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
