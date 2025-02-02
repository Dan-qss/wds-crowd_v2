export default class PieChartManagerfm {
    constructor() {
        this.chart = null;
        this.updateInterval = null;
        this.initializeChart();
        this.startDataFetching();
    }

    initializeChart() {
        const canvas = document.getElementById('pieChart-fm');
        if (!canvas) {
            console.error('Pie chart canvas element not found');
            return;
        }

        const ctx = canvas.getContext('2d');

        this.chart = new Chart(ctx, {
            type: 'doughnut',
            data: {
                labels: ['Male', 'Female'],
                datasets: [{
                    data: [0, 0],
                    backgroundColor: [
                        
                        'rgba(123, 187, 218, 0.8)',
                        'rgba(224, 101, 218, 0.8)'
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
                            padding: 15,
                            font: {
                                size: 10,
                                family: "'Segoe UI', sans-serif"
                            },
                            color: '#fff',
                            generateLabels: (chart) => {
                                const data = chart.data;
                                const dataset = data.datasets[0];
                                return data.labels.map((label, i) => ({
                                    text: `${label} (${dataset.data[i]}%)`,
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
                        padding: 10,
                        callbacks: {
                            label: (context) => {
                                const value = context.parsed;
                                const absoluteValue = this.chart.data.absoluteValues[context.dataIndex];
                                return `${context.label}: ${value}% (${absoluteValue} people)`;
                            }
                        }
                    }
                }
            }
        });
    }

    async fetchData() {
        try {
            const response = await fetch('http://192.168.100.219:8020/gender-stats/');
            if (!response.ok) {
                throw new Error(`HTTP error! status: ${response.status}`);
            }
            const data = await response.json();
            
            // Store absolute values for tooltip
            this.chart.data.absoluteValues = data.absolute_values;
            
            // Update chart data
            this.chart.data.datasets[0].data = data.values;
            
            // Ensure labels match the API response
            this.chart.data.labels = data.labels.map(label => 
                label.charAt(0).toUpperCase() + label.slice(1).toLowerCase()
            );
            
            this.chart.update();
        } catch (error) {
            console.error('Error fetching gender distribution data:', error);
        }
    }

    startDataFetching() {
        // Initial fetch
        this.fetchData();
        
        // Set up interval for updates every 5 seconds
        this.updateInterval = setInterval(() => {
            this.fetchData();
        }, 5000);
    }

    destroy() {
        // Clean up resources
        if (this.updateInterval) {
            clearInterval(this.updateInterval);
        }
        if (this.chart) {
            this.chart.destroy();
            this.chart = null;
        }
    }
}