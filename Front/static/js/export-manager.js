(function () {
  class ExportManager {
    constructor(buttonId = "export-btn") {
      this.btn = document.getElementById(buttonId);
    }

    attach(getStateFn) {
      if (!this.btn) return;
      this.btn.addEventListener("click", () => {
        const state = getStateFn?.() || {};
        const blob = new Blob([JSON.stringify(state, null, 2)], { type: "application/json" });
        const url = URL.createObjectURL(blob);

        const a = document.createElement("a");
        a.href = url;
        a.download = `dashboard_export_${Date.now()}.json`;
        document.body.appendChild(a);
        a.click();
        a.remove();

        URL.revokeObjectURL(url);
      });
    }
  }

  window.ExportManager = ExportManager;
})();
