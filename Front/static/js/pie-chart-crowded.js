export default class PieChartCrowded {
    constructor() {
        this.chart = null;
        this.updateInterval = null;
        this.useMockData = true; // Flag to use mock data
        this.initializeChart();
        this.startAutoUpdate();
    }

    initializeChart() {
        const canvas = document.getElementById('pieChart-crowded');
        if (!canvas) {
            console.error('Pie chart canvas element not found');
            return;
        }

        const ctx = canvas.getContext('2d');

        this.chart = new Chart(ctx, {
            type: 'doughnut',
            data: {
                labels: ['Software Lab', 'Robotics Lab', 'Showroom', 'Marketing & Sales'],
                datasets: [{
                    data: [0, 0, 0, 0],
                    backgroundColor: [
                        '#4CAF50',    // Green
                        '#2196F3',    // Blue
                        '#FFC107',    // Yellow
                        '#9C27B0'     // Purple
                    ],
                    borderWidth: 0,
                    hoverOffset: 4
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                cutout: '65%',
                layout: {
                    padding: {
                        left: 15,
                        right: 15,
                        top: -10,
                        bottom: 5
                    }
                },
                plugins: {
                    legend: {
                        position: 'right',
                        align: 'center',
                        labels: {
                            usePointStyle: true,
                            pointStyle: 'circle',
                            padding: 8,
                            font: {
                                size: 10,
                                family: "'Segoe UI', sans-serif"
                            },
                            color: '#fff',
                            boxWidth: 6,
                            boxHeight: 6,
                            generateLabels: (chart) => {
                                const data = chart.data;
                                const dataset = data.datasets[0];
                                return data.labels.map((label, i) => ({
                                    text: `${label} (${dataset.data[i].toFixed(1)}%)`,
                                    fillStyle: dataset.backgroundColor[i],
                                    hidden: false,
                                    index: i,
                                    fontColor: '#fff'
                                }));
                            }
                        }
                    },
                    tooltip: {
                        enabled: true,
                        backgroundColor: 'rgba(0, 0, 0, 0.8)',
                        titleFont: {
                            size: 11
                        },
                        bodyFont: {
                            size: 11
                        },
                        padding: 8,
                        callbacks: {
                            label: (context) => {
                                return `${context.label}: ${context.parsed.toFixed(1)}%`;
                            }
                        }
                    }
                }
            }
        });
    }

    generateMockData() {
        // Generate random percentages that sum to 100
        const total = 100;
        const randomValues = [];
        let remaining = total;
        
        // Generate random values for first 3 items
        for (let i = 0; i < 3; i++) {
            const max = remaining - (3 - i);
            const value = Math.random() * (max * 0.8); // Using 0.8 to ensure more balanced distribution
            randomValues.push(value);
            remaining -= value;
        }
        
        // Last value is whatever remains to sum to 100
        randomValues.push(remaining);
        
        return {
            software: randomValues[0],
            robotics: randomValues[1],
            showroom: randomValues[2],
            sales: randomValues[3]
        };
    }

    async updateLatestData() {
        if (this.useMockData) {
            const mockData = this.generateMockData();
            this.updateData(mockData);
            return;
        }

        // Original API call code...
        const endTime = new Date();
        const startTime = new Date(endTime - (60 * 1000));

        try {
            const url = `http://192.168.100.65:8010/analysis/zone-occupancy?start_time=${encodeURIComponent(this.formatDateTime(startTime))}&end_time=${encodeURIComponent(this.formatDateTime(endTime))}`;
            const response = await fetch(url);

            if (!response.ok) {
                throw new Error(`HTTP error! status: ${response.status}`);
            }

            const data = await response.json();
            
            if (data.chart_data) {
                const chartValues = {
                    software: data.chart_data.values[data.chart_data.labels.indexOf('software_lab')] || 0,
                    robotics: data.chart_data.values[data.chart_data.labels.indexOf('robotics_lab')] || 0,
                    showroom: data.chart_data.values[data.chart_data.labels.indexOf('showroom')] || 0,
                    sales: data.chart_data.values[data.chart_data.labels.indexOf('marketing-&-sales')] || 0
                };
                
                this.updateData(chartValues);
            }
        } catch (error) {
            // If API fails, use mock data
            const mockData = this.generateMockData();
            this.updateData(mockData);
        }
    }

    startAutoUpdate() {
        this.updateLatestData();
        this.updateInterval = setInterval(() => {
            this.updateLatestData();
        }, 2000);
    }

    stopAutoUpdate() {
        if (this.updateInterval) {
            clearInterval(this.updateInterval);
            this.updateInterval = null;
        }
    }

    updateData(data) {
        if (this.chart) {
            this.chart.data.datasets[0].data = [
                data.software,
                data.robotics,
                data.showroom,
                data.sales
            ];
            this.chart.update();
        }
    }

    destroy() {
        this.stopAutoUpdate();
        if (this.chart) {
            this.chart.destroy();
            this.chart = null;
        }
    }
}