(function () {
  class ExportManager {
    constructor(buttonId = "export-btn", apiBaseUrl = "http://192.168.1.11:8010") {
      this.btn = document.getElementById(buttonId);
      this.apiBaseUrl = apiBaseUrl;
    }

    async attach(getStateFn) {
      if (!this.btn) return;
      
      this.btn.addEventListener("click", async () => {
        try {
          const startDateInput = document.getElementById("date-from");
          const endDateInput = document.getElementById("date-to");
          
          if (!startDateInput || !endDateInput) {
            alert("Date range picker not found. Please ensure date inputs are available.");
            return;
          }
          
          const startDate = startDateInput.value;
          const endDate = endDateInput.value;
          
          if (!startDate || !endDate) {
            alert("Please select a date range before exporting.");
            return;
          }
          
          if (endDate < startDate) {
            alert("End date must be after start date.");
            return;
          }
          
          this.btn.disabled = true;
          this.btn.textContent = "Generating Report...";
          const MIN_DATE = "2026-02-06";
          const MAX_DATE = "2026-02-12";

          if (startDate < MIN_DATE || startDate > MAX_DATE || endDate < MIN_DATE || endDate > MAX_DATE) {
            alert("التصدير مسموح فقط بين 06-02-2026 و 12-02-2026.");
            return;
}

          const reportUrl = `${this.apiBaseUrl}/reports/generate?start_date=${startDate}&end_date=${endDate}&format=pdf`;
          
          const response = await fetch(reportUrl);
          
          if (!response.ok) {
            const errorData = await response.json().catch(() => ({ detail: "Unknown error" }));
            throw new Error(errorData.detail || `HTTP error! status: ${response.status}`);
          }
          
          const blob = await response.blob();
          const url = URL.createObjectURL(blob);
          
          const reportType = startDate === endDate ? "daily" : "multi_day";
          const filename = `crowd_report_${reportType}_${startDate}_${endDate}.pdf`;
          
          const a = document.createElement("a");
          a.href = url;
          a.download = filename;
          document.body.appendChild(a);
          a.click();
          a.remove();
          
          URL.revokeObjectURL(url);
          
          this.btn.textContent = "Export Data";
          this.btn.disabled = false;
          
        } catch (error) {
          console.error("Export error:", error);
          alert(`Failed to generate report: ${error.message}`);
          this.btn.textContent = "Export Data";
          this.btn.disabled = false;
        }
      });
    }
  }

  window.ExportManager = ExportManager;
})();
