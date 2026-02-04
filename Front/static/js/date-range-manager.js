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
        this._updateDisplay();
        this._close();
        this.onApply?.({ from: this.inputFrom.value, to: this.inputTo.value });
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
