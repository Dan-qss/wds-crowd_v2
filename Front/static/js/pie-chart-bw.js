export default class PieChartManagerbw {
    constructor() {
        this.chart = null;
        this.updateInterval = null;
        this.initializeChart();
        this.startDataFetching();
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

    async fetchData() {
        const endTime = new Date();
        const startTime = new Date(endTime - (180 * 60 * 1000)); // Last 3 hour of data
        
        try {
            const url = `http://192.168.100.219:8020/status-stats/time?start_time=${encodeURIComponent(this.formatDateTime(startTime))}&end_time=${encodeURIComponent(this.formatDateTime(endTime))}`;
            const response = await fetch(url);

            if (!response.ok) {
                throw new Error(`HTTP error! status: ${response.status}`);
            }
            const data = await response.json();
            
            if (data && data.values && data.labels) {
                // Create a map of status to value
                const statusMap = {};
                data.labels.forEach((label, index) => {
                    // Map 'black' to 'blacklist' and 'white' to 'whitelist'
                    const mappedLabel = label === 'black' ? 'blacklist' : 
                                      label === 'white' ? 'whitelist' : label;
                    statusMap[mappedLabel] = {
                        value: data.values[index],
                        absolute: data.absolute_values[index]
                    };
                });

                // Get values in the correct order
                const chartData = ['blacklist', 'whitelist'].map(status => 
                    statusMap[status] ? statusMap[status].value : 0
                );

                const absoluteValues = ['blacklist', 'whitelist'].map(status => 
                    statusMap[status] ? statusMap[status].absolute : 0
                );

                // Update the chart
                this.chart.data.datasets[0].data = chartData;
                this.chart.data.absoluteValues = absoluteValues;
                this.chart.update();

               
            }
        } catch (error) {
            console.error('Error fetching status distribution data:', error);
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