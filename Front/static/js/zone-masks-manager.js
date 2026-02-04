// static/js/zone-masks-manager.js
export default class ZoneMasksManager {
  constructor({
    containerId = "heatmap-container",
    overlaySelector = ".heatmap-overlay",
    regionsJsonUrl = "../static/img/regions.json",

    // شكل الماسك
    fill = "rgba(255,255,255,0.06)",
    showBorders = true,

    // أسماء المناطق (5 أسماء)
    zoneNames = {
      1: "Barista Robot",
      2: "FlyNow",
      3: "Drones",
      4: "Fixar aircraft",
      5: "V-BAT aircraft",
    },

    // ستايل النص
    labelFill = "rgba(255,255,255,0.95)",
    labelFontSize = 18,
    labelBg = "rgba(0,0,0,0.65)",

    // padding للبوكس حول النص
    labelPadX = 12,
    labelPadY = 7,
    labelRadius = 10,
  } = {}) {
    this.containerId = containerId;
    this.overlaySelector = overlaySelector;
    this.regionsJsonUrl = regionsJsonUrl;

    this.fill = fill;
    this.showBorders = showBorders;

    this.zoneNames = zoneNames;
    this.labelFill = labelFill;
    this.labelFontSize = labelFontSize;
    this.labelBg = labelBg;

    this.labelPadX = labelPadX;
    this.labelPadY = labelPadY;
    this.labelRadius = labelRadius;

    this.svg = null;
  }

  // centroid حقيقي للـ polygon
  polygonCentroid(points) {
    let area = 0, cx = 0, cy = 0;
    for (let i = 0, j = points.length - 1; i < points.length; j = i++) {
      const p1 = points[j], p2 = points[i];
      const f = p1.x * p2.y - p2.x * p1.y;
      area += f;
      cx += (p1.x + p2.x) * f;
      cy += (p1.y + p2.y) * f;
    }
    area *= 0.5;

    if (Math.abs(area) < 1e-6) {
      const mx = points.reduce((s, p) => s + p.x, 0) / points.length;
      const my = points.reduce((s, p) => s + p.y, 0) / points.length;
      return { x: mx, y: my };
    }

    cx /= (6 * area);
    cy /= (6 * area);
    return { x: cx, y: cy };
  }

  async start() {
    const container = document.getElementById(this.containerId);
    if (!container) return console.warn("ZoneMasksManager: container not found");

    const overlay = container.querySelector(this.overlaySelector);
    if (!overlay) return console.warn("ZoneMasksManager: overlay not found");

    const res = await fetch(this.regionsJsonUrl, { cache: "no-store" });
    if (!res.ok) return console.warn("ZoneMasksManager: failed to fetch regions.json", res.status);

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

    // paths تحت، labels فوق
    const gPaths = document.createElementNS("http://www.w3.org/2000/svg", "g");
    const gLabels = document.createElementNS("http://www.w3.org/2000/svg", "g");

    zones.forEach((z) => {
      const pts = z.points || [];
      if (pts.length < 3) return;

      // ---- PATH ----
      const d = "M " + pts.map((p) => `${p.x} ${p.y}`).join(" L ") + " Z";
      const path = document.createElementNS("http://www.w3.org/2000/svg", "path");
      path.setAttribute("d", d);
      path.setAttribute("id", `zone-${z.id}`);
      path.dataset.zoneId = String(z.id);

      path.setAttribute("fill", this.fill);

      if (this.showBorders) {
        path.setAttribute("stroke", "rgba(0,0,0,0.6)"); // بوردر أغمق
        path.setAttribute("stroke-width", "1.6");
        path.setAttribute("vector-effect", "non-scaling-stroke");
      }

      gPaths.appendChild(path);

      // ---- LABEL (Group per zone) ----
      const c = this.polygonCentroid(pts);
      const name = this.zoneNames?.[z.id] ?? `Zone ${z.id}`;

      const labelGroup = document.createElementNS("http://www.w3.org/2000/svg", "g");
      labelGroup.setAttribute("data-label-zone", String(z.id));

      // text أولاً عشان نحسب bbox
      const text = document.createElementNS("http://www.w3.org/2000/svg", "text");
      text.setAttribute("x", c.x);
      text.setAttribute("y", c.y);
      text.setAttribute("text-anchor", "middle");
      text.setAttribute("dominant-baseline", "middle");
      text.setAttribute("fill", this.labelFill);
      text.setAttribute("font-size", String(this.labelFontSize));
      text.setAttribute("font-weight", "700");

      // outline للنص
      text.setAttribute("paint-order", "stroke");
      text.setAttribute("stroke", "rgba(0,0,0,0.8)");
      text.setAttribute("stroke-width", "2");

      text.textContent = name;

      // لازم ينضاف للـ DOM داخل SVG عشان getBBox يشتغل صح
      labelGroup.appendChild(text);
      gLabels.appendChild(labelGroup);

      // بوكس ديناميكي حسب حجم النص
      if (this.labelBg) {
        // بعد الإضافة نقدر نحسب bbox
        const bb = text.getBBox();

        const bg = document.createElementNS("http://www.w3.org/2000/svg", "rect");
        bg.setAttribute("x", bb.x - this.labelPadX);
        bg.setAttribute("y", bb.y - this.labelPadY);
        bg.setAttribute("width", bb.width + this.labelPadX * 2);
        bg.setAttribute("height", bb.height + this.labelPadY * 2);
        bg.setAttribute("rx", String(this.labelRadius));
        bg.setAttribute("fill", this.labelBg);

        // بوردر للبوكس
        bg.setAttribute("stroke", "rgba(0,0,0,0.65)");
        bg.setAttribute("stroke-width", "1");

        // نخلي البوكس خلف النص
        labelGroup.insertBefore(bg, text);
      }
    });

    svg.appendChild(gPaths);
    svg.appendChild(gLabels);

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
