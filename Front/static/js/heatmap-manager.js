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

        Object.assign(this.layer.style, {
          position: "absolute",
          inset: "0",
          pointerEvents: "none",
          overflow: "hidden",

          // ✅ أقل "نيون" من screen
          mixBlendMode: "soft-light",

          // ✅ عام
          opacity: "0.95",
          zIndex: "2",
        });

        // Insert before the existing .heatmap-overlay so SVG labels stay on top
        const zonesOverlay = this.container.querySelector(".heatmap-overlay");
        if (zonesOverlay) this.container.insertBefore(this.layer, zonesOverlay);
        else this.container.appendChild(this.layer);
      }
    }

    // دمج نقاط قريبة (يساعد كثير مع الداتا الحقيقية)
    _mergePoints(points) {
      const clamp = (v, a, b) => Math.max(a, Math.min(b, v));
      const num = (v, d) => (Number.isFinite(Number(v)) ? Number(v) : d);

      // ✅ حجم خلية الشبكة: صغّريها إذا بدك تفاصيل أكثر، كبّريها إذا بدك نعومة أكثر
      const cell = 0.04;

      const buckets = new Map();

      (points || []).forEach((p) => {
        const x = clamp(num(p.x, 0.5), 0, 1);
        const y = clamp(num(p.y, 0.5), 0, 1);
        const r = clamp(num(p.r, 0.22), 0.06, 0.75);
        const level = (p.level || "low").toLowerCase();

        const gx = Math.round(x / cell);
        const gy = Math.round(y / cell);
        const key = `${gx},${gy},${level}`;

        const cur = buckets.get(key) || { x: 0, y: 0, r: 0, n: 0, level };
        cur.x += x;
        cur.y += y;

        // خذي أكبر r أساس، وبعدين كبّريه حسب كثافة النقاط
        cur.r = Math.max(cur.r, r);

        cur.n += 1;
        buckets.set(key, cur);
      });

      const merged = [...buckets.values()].map((b) => {
        const n = b.n || 1;
        const scale = 1 + Math.log1p(n) * 0.35; // ✅ تكبير لطيف حسب الكثافة

        return {
          x: b.x / n,
          y: b.y / n,
          r: Math.min(0.75, b.r * scale),
          level: b.level,
          n,
        };
      });

      return merged;
    }

    update(points) {
      if (!this.layer) return;

      // Clear ONLY our heat layer (do not touch .heatmap-overlay)
      this.layer.innerHTML = "";

      // ✅ دمج نقاط الداتا الحقيقية
      const merged = this._mergePoints(points);

      const clamp = (v, a, b) => Math.max(a, Math.min(b, v));
      const num = (v, d) => (Number.isFinite(Number(v)) ? Number(v) : d);

      (merged || []).forEach((p) => {
        const x = clamp(num(p.x, 0.5), 0, 1);
        const y = clamp(num(p.y, 0.5), 0, 1);
        const r = clamp(num(p.r, 0.22), 0.06, 0.75);

        const level = (p.level || "low").toLowerCase();

        // ✅ ألوان أهدى (RGBA) بدل RGB النيّون
        const color =
          level === "high"
            ? "rgba(239, 68, 68, 0.55)"
            : level === "moderate"
            ? "rgba(234, 178, 8, 0.50)"
            : "rgba(34, 197, 94, 0.45)";

        const el = document.createElement("div");
        el.className = "heat-zone";

        // Position/size
        el.style.position = "absolute";
        el.style.left = `${(x - r) * 100}%`;
        el.style.top = `${(y - r) * 100}%`;
        el.style.width = `${r * 2 * 100}%`;
        el.style.height = `${r * 2 * 100}%`;
        el.style.borderRadius = "9999px";

        // ✅ تدرّج أطول عشان يصير أنعم
        el.style.background = `radial-gradient(ellipse 90% 85% at 50% 50%, ${color} 0%, rgba(0,0,0,0) 88%)`;

        // ✅ blur ديناميكي حسب الحجم (يعطي نعومة زي "الفيك")
        const blurPx = Math.round(12 + r * 60);
        el.style.filter = `blur(${blurPx}px)`;

        // ✅ opacity ممكن تخفيفها شوي إذا لسه قوي
        el.style.opacity = "1";

        this.layer.appendChild(el);
      });
    }
  }

  window.HeatmapManager = HeatmapManager;
})();
