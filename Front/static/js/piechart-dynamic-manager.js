// static/js/piechart-dynamic-manager.js
export default class PieChartDynamicManager {
  constructor({
    crowdApiBase,
    canvasId = "pieChart2",
    updateMs = 2000,
    windowSeconds = 60,
  } = {}) {
    this.base = (crowdApiBase || "").replace(/\/$/, "");
    this.canvasId = canvasId;
    this.updateMs = updateMs;
    this.windowSeconds = windowSeconds;

    this.chart = null;
    this.timer = null;
    this.mockMode = true;
    this.mockZonesCount = 4;   // عدد مناطق وهمي مؤقت

    this._initChart();
  }

  _initChart() {
    const canvas = document.getElementById(this.canvasId);
    if (!canvas) {
      console.error("Pie chart canvas not found:", this.canvasId);
      return;
    }
    const ctx = canvas.getContext("2d");

    this.chart = new Chart(ctx, {
      type: "doughnut",
      data: {
        labels: [],
        datasets: [
          {
            data: [],
            borderWidth: 0,
            hoverOffset: 4,
            backgroundColor: [],
          },
        ],
      },
      options: {
        responsive: true,
        maintainAspectRatio: false,
        cutout: "65%",
        plugins: {
          legend: {
            position: "right",
            labels: {
              color: "#fff",
              font: { size: 10, family: "'Segoe UI', sans-serif" },
              usePointStyle: true,
              pointStyle: "circle",
              padding: 10,
              generateLabels: (chart) => {
                const data = chart.data;
                const vals = data.datasets?.[0]?.data || [];
                return (data.labels || []).map((label, i) => ({
                  text: `${label} ${Number(vals[i] || 0).toFixed(1)}%`,
                  fillStyle: data.datasets[0].backgroundColor[i],
                  hidden: false,
                  index: i,
                  fontColor: "#fff",
                }));
              },
            },
          },
          tooltip: {
            enabled: true,
            callbacks: {
              label: (context) => `${context.label}: ${Number(context.parsed).toFixed(1)}%`,
            },
          },
        },
      },
    });
  }

  start() {
    this.stop();
    this.updateLatestData();
    this.timer = setInterval(() => this.updateLatestData(), this.updateMs);
  }

  stop() {
    if (this.timer) clearInterval(this.timer);
    this.timer = null;
  }

  destroy() {
    this.stop();
    if (this.chart) this.chart.destroy();
    this.chart = null;
  }

async updateLatestData() {
  if (!this.chart) return;

  // إذا ما في API base أصلاً → mock
  if (!this.base) {
    this._applyMockData();
    return;
  }

  const end = new Date();
  const start = new Date(end.getTime() - this.windowSeconds * 1000);

  const url =
    `${this.base}/analysis/zone-occupancy?start_time=${encodeURIComponent(this._fmt(start))}` +
    `&end_time=${encodeURIComponent(this._fmt(end))}`;

  try {
    const res = await fetch(url);
    if (!res.ok) throw new Error(`HTTP ${res.status}`);
    const data = await res.json();

    const labelsRaw = data?.chart_data?.labels || [];
    const valuesRaw = data?.chart_data?.values || [];

    // إذا رجع فاضي (مثلاً DB فاضية) خليه mock لسه
    if (!labelsRaw.length || !valuesRaw.length) {
      this._applyMockData();
      return;
    }

    // ✅ صار عندنا داتا حقيقية → نطفي mock mode
    this.mockMode = false;

    const labels = labelsRaw.map(this._prettifyZoneName);
    const values = valuesRaw.map(v => Number(v) || 0);

    this.chart.data.labels = labels;
    this.chart.data.datasets[0].data = values;
    this.chart.data.datasets[0].backgroundColor = this._makeColors(labels.length);

    this.chart.update();
  } catch (e) {
    // ✅ أي فشل بالـ API → mock data
    this._applyMockData();
  }
}

_applyMockData() {
  // خليها تضل تتحرك “smooth” كل تحديث
  const zones = Array.from({ length: this.mockZonesCount }, (_, i) => `Zone ${i + 1}`);

  // توليد نسب مجموعها 100%
  const raw = zones.map(() => Math.random());
  const sum = raw.reduce((a, b) => a + b, 0) || 1;
  const values = raw.map(v => (v / sum) * 100);

  this.chart.data.labels = zones;
  this.chart.data.datasets[0].data = values;
  this.chart.data.datasets[0].backgroundColor = this._makeColors(zones.length);

  this.chart.update();
}


  _fmt(d) {
    const pad = (n) => String(n).padStart(2, "0");
    return `${d.getFullYear()}-${pad(d.getMonth() + 1)}-${pad(d.getDate())} ${pad(d.getHours())}:${pad(
      d.getMinutes()
    )}:${pad(d.getSeconds())}`;
  }

  _prettifyZoneName(z) {
    return String(z || "")
      .replace(/[-_]+/g, " ")
      .trim()
      .replace(/\b\w/g, (c) => c.toUpperCase());
  }

  _makeColors(n) {
    const palette = [
      "#4CAF50",
      "#2196F3",
      "#FFC107",
      "#9C27B0",
      "#00BCD4",
      "#FF5722",
      "#8BC34A",
      "#E91E63",
      "#3F51B5",
      "#CDDC39",
    ];
    const out = [];
    for (let i = 0; i < n; i++) out.push(palette[i % palette.length]);
    return out;
  }
}
