export default class ChartManager {
    constructor() {
        this.chart = null;
        this.updateInterval = null;
        this.initializeChart();
        this.startAutoUpdate();
        console.log('Line Chart Manager initialized');
    }

    generateTimeLabels() {
        const labels = [];
        // Generate labels including quarter hours
        for (let hour = 8; hour <= 17; hour++) {
            // Add hour label
            if (hour === 12) {
                labels.push('12 PM');
            } else if (hour > 12) {
                labels.push(`${hour - 12} PM`);
            } else {
                labels.push(`${hour} AM`);
            }
            
            // Add three dots for quarter hours
            if (hour < 17) { // Don't add dots after 5 PM
                labels.push('•', '•', '•');
            }
        }
        return labels;
    }

    initializeChart() {
        const ctx = document.getElementById('timePercentageChart').getContext('2d');
        
        this.chart = new Chart(ctx, {
            type: 'line',
            data: {
                labels: this.generateTimeLabels(),
                datasets: [
                    {
                        label: 'Software Lab',
                        data: Array(37).fill(0), // 9 hours * 4 points + 1 final point = 37 points
                        borderColor: '#4CAF50',
                        backgroundColor: 'rgba(76, 175, 80, 0.1)',
                        borderWidth: 2,
                        pointRadius: (context) => {
                            // Show larger points for hour marks, smaller for quarter hours
                            return context.dataIndex % 4 === 0 ? 3 : 1;
                        },
                        pointBackgroundColor: '#4CAF50',
                        fill: false,
                        tension: 0.4
                    },
                    {
                        label: 'Robotics Lab',
                        data: Array(37).fill(0),
                        borderColor: '#2196F3',
                        backgroundColor: 'rgba(33, 150, 243, 0.1)',
                        borderWidth: 2,
                        pointRadius: (context) => {
                            return context.dataIndex % 4 === 0 ? 3 : 1;
                        },
                        pointBackgroundColor: '#2196F3',
                        fill: false,
                        tension: 0.4
                    },
                    {
                        label: 'Showroom',
                        data: Array(37).fill(0),
                        borderColor: '#FFC107',
                        backgroundColor: 'rgba(255, 193, 7, 0.1)',
                        borderWidth: 2,
                        pointRadius: (context) => {
                            return context.dataIndex % 4 === 0 ? 3 : 1;
                        },
                        pointBackgroundColor: '#FFC107',
                        fill: false,
                        tension: 0.4
                    },
                    {
                        label: 'Marketing & Sales',
                        data: Array(37).fill(0),
                        borderColor: '#9C27B0',
                        backgroundColor: 'rgba(156, 39, 176, 0.1)',
                        borderWidth: 2,
                        pointRadius: (context) => {
                            return context.dataIndex % 4 === 0 ? 3 : 1;
                        },
                        pointBackgroundColor: '#9C27B0',
                        fill: false,
                        tension: 0.4
                    }
                ]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: {
                    legend: {
                        display: true,
                        position: 'top',
                        align: 'end',
                        labels: {
                            boxWidth: 12,
                            padding: 8,
                            font: {
                                size: 10
                            }
                        }
                    },
                    tooltip: {
                        backgroundColor: 'rgba(0, 0, 0, 0.7)',
                        padding: 6,
                        titleFont: {
                            size: 10
                        },
                        bodyFont: {
                            size: 10
                        },
                        callbacks: {
                            title: function(context) {
                                const dataIndex = context[0].dataIndex;
                                const hour = Math.floor(dataIndex / 4) + 8;
                                const minutes = (dataIndex % 4) * 15;
                                const period = hour >= 12 ? 'PM' : 'AM';
                                const displayHour = hour > 12 ? hour - 12 : hour;
                                return `${displayHour}:${minutes.toString().padStart(2, '0')} ${period}`;
                            },
                            label: function(context) {
                                return `${context.dataset.label}: ${context.parsed.y.toFixed(1)}%`;
                            }
                        }
                    }
                },
                scales: {
                    y: {
                        beginAtZero: true,
                        max: 100,
                        ticks: {
                            color: '#666',
                            padding: 4,
                            font: {
                                size: 10
                            },
                            callback: function(value) {
                                return value + '%';
                            }
                        },
                        grid: {
                            color: 'rgba(200, 200, 200, 0.2)',
                            drawBorder: false
                        }
                    },
                    x: {
                        ticks: {
                            color: '#666',
                            padding: 4,
                            font: {
                                size: 10
                            },
                            callback: function(value, index) {
                                // Only show labels for hour marks (every 4th index)
                                return index % 4 === 0 ? this.getLabelForValue(value) : '';
                            }
                        },
                        grid: {
                            display: false
                        }
                    }
                }
            }
        });
    }

    async updateLatestData() {
        const now = new Date();
        const currentHour = now.getHours();
        const currentMinute = now.getMinutes();
        
        // Only update during business hours (8 AM to 5 PM)
        if (currentHour < 8 || currentHour >= 17) {
            console.log('Outside business hours, skipping update');
            return;
        }

        const endTime = new Date();
        const startTime = new Date(endTime - (5 * 60 * 1000)); // 1 minute ago

        try {
            const url = `http://127.0.0.1:8050/analysis/zone-occupancy?start_time=${encodeURIComponent(this.formatDateTime(startTime))}&end_time=${encodeURIComponent(this.formatDateTime(endTime))}`;
            
            const response = await fetch(url);

            if (!response.ok) {
                throw new Error(`HTTP error! status: ${response.status}`);
            }

            const data = await response.json();
            
            if (data.chart_data) {
                // Calculate the index for the current time
                const hourIndex = currentHour - 8;
                const quarterIndex = Math.floor(currentMinute / 15);
                const dataIndex = hourIndex * 4 + quarterIndex;

                const newValues = {
                    software: data.chart_data.absolute_values[data.chart_data.labels.indexOf('software_lab')] || 0,
                    robotics: data.chart_data.absolute_values[data.chart_data.labels.indexOf('robotics_lab')] || 0,
                    showroom: data.chart_data.absolute_values[data.chart_data.labels.indexOf('showroom')] || 0,
                    sales: data.chart_data.absolute_values[data.chart_data.labels.indexOf('marketing-&-sales')] || 0
                };

                // Update the data at the current quarter-hour position
                this.chart.data.datasets[0].data[dataIndex] = newValues.software;
                this.chart.data.datasets[1].data[dataIndex] = newValues.robotics;
                this.chart.data.datasets[2].data[dataIndex] = newValues.showroom;
                this.chart.data.datasets[3].data[dataIndex] = newValues.sales;

                this.chart.update();
                console.log(`Chart updated for ${currentHour}:${currentMinute.toString().padStart(2, '0')}`);
            }
        } catch (error) {
            console.error('Error updating line chart:', error);
        }
    }

    formatDateTime(date) {
        const pad = (num) => String(num).padStart(2, '0');
        return `${date.getFullYear()}-${pad(date.getMonth() + 1)}-${pad(date.getDate())} ${pad(date.getHours())}:${pad(date.getMinutes())}:${pad(date.getSeconds())}`;
    }

    startAutoUpdate() {
        console.log('Starting line chart auto-update (1 minute interval)');
        this.updateLatestData();
        this.updateInterval = setInterval(() => {
            this.updateLatestData();
        }, 5 *  60 * 1000);
    }

    stopAutoUpdate() {
        if (this.updateInterval) {
            clearInterval(this.updateInterval);
            this.updateInterval = null;
            console.log('Line chart auto-update stopped');
        }
    }

    destroy() {
        this.stopAutoUpdate();
        if (this.chart) {
            this.chart.destroy();
            console.log('Line chart destroyed');
        }
    }
}