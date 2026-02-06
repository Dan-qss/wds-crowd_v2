(function () {
  class DateRangeManager {
    constructor({ triggerId, pickerId, displayId, fromId, toId, applyId, onApply } = {}) {
      this.trigger = document.getElementById(triggerId);
      this.picker = document.getElementById(pickerId);
      this.display = document.getElementById(displayId);
      this.inputFrom = document.getElementById(fromId);
      this.inputTo = document.getElementById(toId);
      this.applyBtn = document.getElementById(applyId);
      this.onApply = onApply;

      // Allowed range
      this.MIN_DATE = "2026-02-06";
      this.MAX_DATE = "2026-02-12";

      // Apply constraints to inputs
      this.inputFrom.min = this.MIN_DATE;
      this.inputFrom.max = this.MAX_DATE;
      this.inputTo.min   = this.MIN_DATE;
      this.inputTo.max   = this.MAX_DATE;

      // Ensure current values are within range
      if (!this.inputFrom.value || this.inputFrom.value < this.MIN_DATE) this.inputFrom.value = this.MIN_DATE;
      if (this.inputFrom.value > this.MAX_DATE) this.inputFrom.value = this.MAX_DATE;

      if (!this.inputTo.value || this.inputTo.value > this.MAX_DATE) this.inputTo.value = this.MAX_DATE;
      if (this.inputTo.value < this.MIN_DATE) this.inputTo.value = this.MIN_DATE;


      if (!this.trigger || !this.picker || !this.display || !this.inputFrom || !this.inputTo || !this.applyBtn) return;
      this._bind();
      this._updateDisplay();
    }

    _formatDisplayDate(dateStr) {
      const d = new Date(dateStr + "T00:00:00");
      const months = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
      return `${months[d.getMonth()]} ${d.getDate()}, ${d.getFullYear()}`;
    }

    _updateDisplay() {
      this.display.textContent =
        `${this._formatDisplayDate(this.inputFrom.value)} - ${this._formatDisplayDate(this.inputTo.value)}`;
    }

    _open() {
      this.picker.classList.remove("hidden");
      this.trigger.setAttribute("aria-expanded", "true");
    }

    _close() {
      this.picker.classList.add("hidden");
      this.trigger.setAttribute("aria-expanded", "false");
    }

    _toggle() {
      if (this.picker.classList.contains("hidden")) this._open();
      else this._close();
    }

    _bind() {
      this.trigger.addEventListener("click", (e) => {
        e.stopPropagation();
        this._toggle();
      });

      this.applyBtn.addEventListener("click", () => {
        const from = this.inputFrom.value;
        const to = this.inputTo.value;

        // Validate range
        if (from < this.MIN_DATE || from > this.MAX_DATE || to < this.MIN_DATE || to > this.MAX_DATE) {
          alert("اختاري تاريخ بين 06-02-2026 و 12-02-2026 فقط.");
          return;
        }
        if (to < from) {
          alert("تاريخ النهاية لازم يكون بعد البداية.");
          return;
        }

        this._updateDisplay();
        this._close();
        this.onApply?.({ from, to });
      });


      this.inputFrom.addEventListener("change", () => this._updateDisplay());
      this.inputTo.addEventListener("change", () => this._updateDisplay());

      document.addEventListener("click", (e) => {
        if (!this.picker.contains(e.target) && e.target !== this.trigger) this._close();
      });
    }
  }

  window.DateRangeManager = DateRangeManager;
})();
