export default class PieChartCrowded {
    constructor() {
        this.chart = null;
        this.updateInterval = null;
        this.initializeChart();
        this.startAutoUpdate();
    }

    initializeChart() {
        const canvas = document.getElementById('pieChart-crowded');
        if (!canvas) {
            console.error('Pie chart 2 canvas element not found');
            return;
        }

        const ctx = canvas.getContext('2d');
        console.log('Canvas context obtained');
        
        this.chart = new Chart(ctx, {
            type: 'doughnut',
            data: {
                labels: ['Drones', 'Barista Robot', 'Mosaed Robot', 'AMR', 'Industrial Robot'],
                datasets: [{
                    data: [0, 0, 0, 0, 0],
                    backgroundColor: [
                        '#4CAF50',    // Green
                        '#2196F3',    // Blue
                        '#FFC107',    // Yellow
                        '#9C27B0',    // Purple
                        '#FF5722'     // Orange (Industrial Robot)
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
                        left: 5,
                        right: 5,
                        top: 5,
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
                            padding: 10,
                            font: {
                                size: 10,
                                family: "'Segoe UI', sans-serif"
                            },
                            color: '#fff',
                            generateLabels: function(chart) {
                                const data = chart.data;
                                return data.labels.map((label, i) => ({
                                    text: `${label} ${data.datasets[0].data[i].toFixed(1)}%`,
                                    fillStyle: data.datasets[0].backgroundColor[i],
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
                            size: 11,
                            color: '#fff'
                        },
                        bodyFont: {
                            size: 11,
                            color: '#fff'
                        },
                        padding: 10,
                        callbacks: {
                            label: function(context) {
                                return `${context.label}: ${context.parsed.toFixed(1)}%`;
                            }
                        },
                        titleColor: '#fff',
                        bodyColor: '#fff'
                    }
                }
            }
        });
    }

    formatDateTime(date) {
        const pad = (num) => String(num).padStart(2, '0');
        
        const year = date.getFullYear();
        const month = pad(date.getMonth() + 1);
        const day = pad(date.getDate());
        const hours = pad(date.getHours());
        const minutes = pad(date.getMinutes());
        const seconds = pad(date.getSeconds());

        return `${year}-${month}-${day} ${hours}:${minutes}:${seconds}`;
    }

    async updateLatestData() {
        const endTime = new Date();
        const startTime = new Date(endTime - (60 * 1000)); // 60 seconds = 1 minute

        try {
            const url = `http://192.168.100.219:8010/analysis/zone-occupancy?start_time=${encodeURIComponent(this.formatDateTime(startTime))}&end_time=${encodeURIComponent(this.formatDateTime(endTime))}`;

            const response = await fetch(url);

            if (!response.ok) {
                console.error('API Response Error:', response.status, response.statusText);
                throw new Error(`HTTP error! status: ${response.status}`);
            }

            const data = await response.json();
            
            if (data.chart_data) {
                const chartValues = {
                    software: data.chart_data.values[data.chart_data.labels.indexOf('software_lab')] || 0,
                    robotics: data.chart_data.values[data.chart_data.labels.indexOf('robotics_lab')] || 0,
                    showroom: data.chart_data.values[data.chart_data.labels.indexOf('showroom')] || 0,
                    sales: data.chart_data.values[data.chart_data.labels.indexOf('marketing-&-sales')] || 0,
                    industrial: data.chart_data.values[data.chart_data.labels.indexOf('industrial_robot')] || 0
                };
                
                this.updateData(chartValues);
            } else {
                console.warn('Invalid or missing chart_data in response:', data);
            }
        } catch (error) {
            console.error('Error updating latest data:', error);
        }
    }

    startAutoUpdate() {
        // Initial update
        this.updateLatestData();

        // Set up interval for updates every 2 seconds
        this.updateInterval = setInterval(() => {
            this.updateLatestData();
        }, 2000);
    }

    stopAutoUpdate() {
        if (this.updateInterval) {
            clearInterval(this.updateInterval);
            this.updateInterval = null;
            console.log('Auto-update stopped');
        }
    }

    updateData(data) {
        if (this.chart) {
            this.chart.data.datasets[0].data = [
                data.software,
                data.robotics,
                data.showroom,
                data.sales,
                data.industrial
            ];
            this.chart.update();
        }
    }

    handleWebSocketData(data) {
        if (data && data.software !== undefined && data.robotics !== undefined && 
            data.showroom !== undefined && data.sales !== undefined &&
            data.industrial !== undefined) {
            this.updateData(data);
        }
    }

    destroy() {
        this.stopAutoUpdate();
        if (this.chart) {
            this.chart.destroy();
        }
    }
}