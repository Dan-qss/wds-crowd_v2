// static/js/zone-masks-manager.js
export default class ZoneMasksManager {
  constructor({
    containerId = "heatmap-container",
    overlaySelector = ".heatmap-overlay",
    regionsJsonUrl = "../static/img/regions.json",

    fill = "rgba(0,0,0,0)",
    showBorders = true,
    borderColor = "rgba(0,0,0,0.6)",
    borderWidth = 1.6,

    // ✅ Debug: click to print zone id
    enableClickDebug = true,
  } = {}) {
    this.containerId = containerId;
    this.overlaySelector = overlaySelector;
    this.regionsJsonUrl = regionsJsonUrl;

    this.fill = fill;
    this.showBorders = showBorders;
    this.borderColor = borderColor;
    this.borderWidth = borderWidth;

    this.enableClickDebug = enableClickDebug;

    this.svg = null;
  }

  async start() {
    const container = document.getElementById(this.containerId);
    if (!container) return console.warn("ZoneMasksManager: container not found");

    const overlay = container.querySelector(this.overlaySelector);
    if (!overlay) return console.warn("ZoneMasksManager: overlay not found");

    const res = await fetch(this.regionsJsonUrl, { cache: "no-store" });
    if (!res.ok) {
      return console.warn("ZoneMasksManager: failed to fetch regions.json", res.status);
    }

    const data = await res.json();

    const W = data.width;
    const H = data.height;
    const zones = data.zones || [];

    const svg = document.createElementNS("http://www.w3.org/2000/svg", "svg");
    svg.setAttribute("viewBox", `0 0 ${W} ${H}`);
    svg.setAttribute("preserveAspectRatio", "xMidYMid meet");
    svg.style.width = "100%";
    svg.style.height = "100%";
    svg.style.display = "block";

    const gPaths = document.createElementNS("http://www.w3.org/2000/svg", "g");

    zones.forEach((z) => {
      const pts = z.points || [];
      if (pts.length < 3) return;

      const d = "M " + pts.map((p) => `${p.x} ${p.y}`).join(" L ") + " Z";

      const path = document.createElementNS("http://www.w3.org/2000/svg", "path");
      path.setAttribute("d", d);
      path.setAttribute("id", `zone-${z.id}`);
      path.dataset.zoneId = String(z.id);

      path.setAttribute("fill", this.fill);

      if (this.showBorders) {
        path.setAttribute("stroke", this.borderColor);
        path.setAttribute("stroke-width", String(this.borderWidth));
        path.setAttribute("vector-effect", "non-scaling-stroke");
      }

      // ✅ Debug: click prints which zone id you clicked
      if (this.enableClickDebug) {
        path.style.cursor = "pointer";
        path.addEventListener("click", () => {
          console.log("Clicked zone id =", z.id);
        });
      }

      gPaths.appendChild(path);
    });

    // Info log (shows [1..5])
    try {
      const zoneInfo = zones.map((z) => ({ id: z.id, name: z.name || null }));
      console.log("ZoneMasksManager: loaded zones:", zoneInfo);
    } catch {}

    svg.appendChild(gPaths);

    overlay.innerHTML = "";
    overlay.appendChild(svg);
    this.svg = svg;
  }

  setZoneColor(zoneId, rgbaColor) {
    const el = document.getElementById(`zone-${zoneId}`);
    if (el) el.setAttribute("fill", rgbaColor);
  }

  destroy() {
    try { this.svg?.remove?.(); } catch {}
    this.svg = null;
  }
}
