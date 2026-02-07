// static/js/face-list-manager.js
export default class FaceListManager {
  constructor({
    baseUrl = "http://192.168.8.130:8020",
    limit = 8,
    pollMs = 1500,
    containerSelector = ".facelist-container",
  } = {}) {
    this.baseUrl = baseUrl.replace(/\/$/, "");
    this.limit = limit;
    this.pollMs = pollMs;
    this.container = document.querySelector(containerSelector);
    this.controller = null;
    this.timer = null;

    this.initialize();
  }

  formatName(name) {
    if (!name) return "";
    return String(name)
      .split("_")
      .map(w => (w ? w[0].toUpperCase() + w.slice(1).toLowerCase() : ""))
      .join(" ");
  }

  formatDateTime(ts) {
    try {
      const d = new Date(ts);
      const time = d.toLocaleTimeString("en-US", { hour: "numeric", minute: "2-digit", hour12: true });
      const date = d.toLocaleDateString("en-US", { year: "numeric", month: "short", day: "numeric" });
      return `${time}, ${date}`;
    } catch {
      return "--";
    }
  }

  statusBadge(status) {
    const s = String(status || "").toLowerCase();
    if (s.includes("black")) return { text: "Black List", icon: "blocked.png", color: "text-alert-red" };
    if (s.includes("white") || s.includes("employee")) return { text: "Employee", icon: "employee.png", color: "text-accent" };
    return { text: status || "Unknown", icon: "employee.png", color: "text-muted" };
  }

  render(data) {
    if (!this.container) return;

    if (!Array.isArray(data) || data.length === 0) {
      this.container.innerHTML = `
        <div class="text-sm text-white/70 bg-black/10 border border-white/10 rounded-lg p-3">
          No recognition data yet.
        </div>
      `;
      return;
    }

    this.container.innerHTML = "";

    data.forEach((row) => {
      const personNameRaw = row.person_name || "unknown";
      const personName = this.formatName(personNameRaw);
    
      const position = row.position || "";
      const time = this.formatDateTime(row.timestamp);
      const badge = this.statusBadge(row.status);

      // إذا عندك صور للأشخاص مثل زمان: ../static/img/persons/{person}.png
      const imgPath = `../static/img/persons/unknown.png`;

      const card = document.createElement("div");
      card.className =
        "flex items-center gap-3 rounded-lg px-3 py-2.5 border border-white/10 shadow-sm shrink-0";
      card.style.backgroundColor = "#1e3d32";

      card.innerHTML = `
        <div class="w-10 h-10 rounded-full bg-slate-600 border border-white/10 flex items-center justify-center shrink-0 overflow-hidden">
          <img src="${imgPath}" onerror="this.style.display='none'" class="w-full h-full object-cover" />
          <svg class="w-5 h-5 text-slate-300" fill="currentColor" viewBox="0 0 24 24">
            <path d="M12 12c2.21 0 4-1.79 4-4s-1.79-4-4-4-4 1.79-4 4 1.79 4 4 4zm0 2c-2.67 0-8 1.34-8 4v2h16v-2c0-2.66-5.33-4-8-4z"/>
          </svg>
        </div>

        <div class="flex-1 min-w-0">
          <p class="font-medium text-sm text-white truncate">${personName}</p>
          <p class="text-xs text-white/70 truncate">${position}</p>
          <p class="text-xs text-white/70 truncate">${time}</p>
          
          <p class="text-sm font-medium ${badge.color}">${badge.text}</p>
        </div>

        <div class="w-8 h-8 flex items-center justify-center shrink-0">
          <img src="../static/img/${badge.icon}" alt="" class="w-8 h-8 object-contain" />
        </div>
      `;

      this.container.appendChild(card);
    });
  }

  async fetchData() {
    if (this.controller) this.controller.abort();
    this.controller = new AbortController();

    try {
      const url = `${this.baseUrl}/recognitions/last/${this.limit}`;
      const res = await fetch(url, { signal: this.controller.signal });

      if (!res.ok) throw new Error(`HTTP ${res.status}`);

      const data = await res.json();
      this.render(data);
    } catch (err) {
      if (err.name !== "AbortError") {
        console.error("FaceList fetch error:", err);
      }
    }
  }

  initialize() {
    this.fetchData();
    this.timer = setInterval(() => this.fetchData(), this.pollMs);
  }

  destroy() {
    if (this.timer) clearInterval(this.timer);
    this.timer = null;
    if (this.controller) this.controller.abort();
    this.controller = null;
  }
}
