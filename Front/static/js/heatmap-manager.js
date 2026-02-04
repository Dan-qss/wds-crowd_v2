(function () {
  class HeatmapManager {
    constructor(containerId = "heatmap-container") {
      this.container = document.getElementById(containerId);
      this.overlay = this.container ? this.container.querySelector(".heatmap-overlay") : null;
    }

    update(points) {
      if (!this.overlay) return;
      this.overlay.innerHTML = "";

      (points || []).forEach(p => {
        const x = DashUtils.clamp(DashUtils.safeNum(p.x, 0.5), 0, 1);
        const y = DashUtils.clamp(DashUtils.safeNum(p.y, 0.5), 0, 1);
        const r = DashUtils.clamp(DashUtils.safeNum(p.r, 0.2), 0.05, 0.6);
        const level = p.level || "low";

        const color =
          level === "high" ? "rgba(239, 68, 68, 0.95)" :
          level === "moderate" ? "rgba(234, 179, 8, 0.92)" :
          "rgba(34, 197, 94, 0.92)";

        const el = document.createElement("div");
        el.className = "heat-zone";
        el.style.left = `${(x - r) * 100}%`;
        el.style.top = `${(y - r) * 100}%`;
        el.style.width = `${(r * 2) * 100}%`;
        el.style.height = `${(r * 2) * 100}%`;
        el.style.background = `radial-gradient(ellipse 90% 85% at 50% 50%, ${color}, transparent 70%)`;

        this.overlay.appendChild(el);
      });
    }
  }

  window.HeatmapManager = HeatmapManager;
})();
