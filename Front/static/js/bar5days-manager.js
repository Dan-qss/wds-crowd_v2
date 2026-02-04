(function () {
  class Bar5DaysManager {
    constructor() {
      this.bars = [1,2,3,4,5].map(i => document.getElementById(`bar-d${i}`));
    }

    update(values) {
      if (!Array.isArray(values)) return;
      for (let i = 0; i < 5; i++) {
        const el = this.bars[i];
        if (!el) continue;
        const v = DashUtils.clamp(DashUtils.safeNum(values[i], 0), 0, 100);
        el.style.height = `${v}%`;
      }
    }
  }

  window.Bar5DaysManager = Bar5DaysManager;
})();
