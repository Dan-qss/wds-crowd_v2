// static/js/heatmap-manager.js
(function () {
  class HeatmapManager {
    constructor(containerId = "heatmap-container") {
      this.container = document.getElementById(containerId);
      if (!this.container) {
        console.warn("HeatmapManager: container not found", containerId);
        this.layer = null;
        return;
      }

      // Create a dedicated heat layer that won't conflict with ZoneMasksManager (.heatmap-overlay)
      this.layer = this.container.querySelector(".heat-soft-layer");
      if (!this.layer) {
        this.layer = document.createElement("div");
        this.layer.className = "heat-soft-layer";
        this.layer.setAttribute("aria-hidden", "true");

        // Make sure it's positioned correctly above the image
        // but below labels if you use ZoneMasksManager on .heatmap-overlay
        Object.assign(this.layer.style, {
          position: "absolute",
          inset: "0",
          pointerEvents: "none",
          overflow: "hidden",
          // This gives the nice blended look like the designer image
          mixBlendMode: "screen",
          opacity: "0.9",
          zIndex: "2", // image is behind; zone overlay can be above if needed
        });

        // Insert before the existing .heatmap-overlay so SVG labels stay on top
        const zonesOverlay = this.container.querySelector(".heatmap-overlay");
        if (zonesOverlay) this.container.insertBefore(this.layer, zonesOverlay);
        else this.container.appendChild(this.layer);
      }
    }

    update(points) {
      if (!this.layer) return;

      // Clear ONLY our heat layer (do not touch .heatmap-overlay)
      this.layer.innerHTML = "";

      (points || []).forEach((p) => {
        // const x = DashUtils.clamp(DashUtils.safeNum(p.x, 0.5), 0, 1);
        // const y = DashUtils.clamp(DashUtils.safeNum(p.y, 0.5), 0, 1);
        // const r = DashUtils.clamp(DashUtils.safeNum(p.r, 0.22), 0.06, 0.75);
        const clamp = (v, a, b) => Math.max(a, Math.min(b, v));
        const num = (v, d) => (Number.isFinite(Number(v)) ? Number(v) : d);

        const x = clamp(num(p.x, 0.5), 0, 1);
        const y = clamp(num(p.y, 0.5), 0, 1);
        const r = clamp(num(p.r, 0.22), 0.06, 0.75);

        const level = (p.level || "low").toLowerCase();

        // Softer alpha to match the designer look (transparent, not solid)
        // You can tweak alpha here if you want stronger/weaker.
        const color =
          level === "high"
            ? "rgb(239, 68, 68)"
            : level === "moderate"
            ? "rgb(234, 178, 8)"
            : "rgb(34, 197, 94)";

        const el = document.createElement("div");
        el.className = "heat-zone";

        // Position/size
        el.style.position = "absolute";
        el.style.left = `${(x - r) * 100}%`;
        el.style.top = `${(y - r) * 100}%`;
        el.style.width = `${r * 2 * 100}%`;
        el.style.height = `${r * 2 * 100}%`;
        el.style.borderRadius = "9999px";

        // Designer-like soft spread + fade
        el.style.background = `radial-gradient(ellipse 90% 85% at 50% 50%, ${color} 0%, rgba(0,0,0,0) 70%)`;

        // Blur/feather
        el.style.filter = "blur(16px)"

        // Slight extra softness so edges disappear nicely
        el.style.opacity = "1";

        this.layer.appendChild(el);
      });
    }
  }

  window.HeatmapManager = HeatmapManager;
})();
