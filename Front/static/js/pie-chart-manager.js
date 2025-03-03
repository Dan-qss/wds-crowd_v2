export default class PieChartManager {
    constructor() {
        this.chart = null;
        this.initializeChart();
        this.startDataFetching();
    }

    initializeChart() {
        const canvas = document.getElementById('pieChart');
        if (!canvas) {
            console.error('Pie chart canvas element not found');
            return;
        }

        const ctx = canvas.getContext('2d');

        this.chart = new Chart(ctx, {
            type: 'doughnut',
            data: {
                labels: ['Blacklist', 'Whitelist'],
                datasets: [{
                    data: [0, 0],
                    backgroundColor: [
                        'rgba(255, 82, 82, 0.8)',  // Red color for blacklist
                        'rgba(76, 175, 80, 0.8)'   // Green color for whitelist
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
                            padding: 15,
                            font: {
                                size: 10,
                                family: "'Segoe UI', sans-serif"
                            },
                            color: '#fff',
                            generateLabels: function(chart) {
                                const data = chart.data;
                                return data.labels.map((label, i) => ({
                                    text: `${label} ${data.datasets[0].data[i]}%`,
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
                                return `${context.label}: ${context.parsed}%`;
                            }
                        },
                        titleColor: '#fff',
                        bodyColor: '#fff'
                    }
                }
            }
        });
    }

    async fetchData() {
        try {
            const response = await fetch('http://192.168.100.52:8020/status-stats/');
            if (!response.ok) {
                throw new Error(`HTTP error! status: ${response.status}`);
            }
            const data = await response.json();
            
            // Convert the API response to the format our chart expects
            const blackIndex = data.labels.indexOf('black');
            const whiteIndex = data.labels.indexOf('white');
            
            this.updateData({
                blacklist: data.values[blackIndex],
                whitelist: data.values[whiteIndex]
            });
        } catch (error) {
            console.error('Error fetching data:', error);
        }
    }

    updateData(data) {
        if (this.chart) {
            this.chart.data.datasets[0].data = [
                data.blacklist,
                data.whitelist
            ];
            this.chart.update();
        }
    }

    startDataFetching() {
        // Initial fetch
        this.fetchData();
        
        // Set up interval for updates every 5 seconds
        setInterval(() => {
            this.fetchData();
        }, 5000);
    }
}