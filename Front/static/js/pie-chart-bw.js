export default class PieChartManagerbw {
    constructor() {
        this.chart = null;
        this.updateInterval = null;
        this.useMockData = true; // Flag to use mock data
        this.initializeChart();
        this.startDataFetching();
    }

    initializeChart() {
        const canvas = document.getElementById('pieChart-bw');
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

    generateMockData() {
        // Generate random whitelist percentage between 70% and 95%
        const whitelistPercentage = 70 + Math.random() * 25;
        const blacklistPercentage = 100 - whitelistPercentage;

        // Generate mock absolute values (total between 50 and 150 people)
        const totalPeople = Math.floor(50 + Math.random() * 100);
        const whitelistPeople = Math.floor((whitelistPercentage / 100) * totalPeople);
        const blacklistPeople = totalPeople - whitelistPeople;

        return {
            values: [blacklistPercentage.toFixed(1), whitelistPercentage.toFixed(1)],
            absolute_values: [blacklistPeople, whitelistPeople],
            labels: ['black', 'white']
        };
    }

    async fetchData() {
        if (this.useMockData) {
            const mockData = this.generateMockData();
            this.updateChartWithData(mockData);
            return;
        }

        try {
            const response = await fetch('http://192.168.100.65:8020/status-stats/');
            if (!response.ok) {
                throw new Error(`HTTP error! status: ${response.status}`);
            }
            const data = await response.json();
            
            const blackIndex = data.labels.indexOf('black');
            const whiteIndex = data.labels.indexOf('white');
            
            if (blackIndex !== -1 && whiteIndex !== -1) {
                this.updateData({
                    blacklist: data.values[blackIndex],
                    whitelist: data.values[whiteIndex]
                });
            }
        } catch (error) {
            console.error('Error fetching data:', error);
            // Fallback to mock data if API fails
            const mockData = this.generateMockData();
            this.updateChartWithData(mockData);
        }
    }

    updateChartWithData(data) {
        if (this.chart) {
            // Store absolute values for tooltip
            this.chart.data.absoluteValues = data.absolute_values;
            
            this.chart.data.datasets[0].data = [
                data.values[0],  // blacklist
                data.values[1]   // whitelist
            ];
            this.chart.update();
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
        this.updateInterval = setInterval(() => {
            this.fetchData();
        }, 5000);
    }

    destroy() {
        if (this.updateInterval) {
            clearInterval(this.updateInterval);
        }
        if (this.chart) {
            this.chart.destroy();
            this.chart = null;
        }
    }
}