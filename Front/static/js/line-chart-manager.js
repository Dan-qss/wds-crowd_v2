export default class ChartManager {
    constructor() {
        this.chart = null;
        this.updateInterval = null;
        this.initializeChart();
        this.initializeHistoricalData();
        this.startAutoUpdate();
        // console.log('Line Chart Manager initialized');
    }

    generateTimeLabels() {
        const labels = [];
        for (let hour = 8; hour <= 17; hour++) {
            if (hour === 12) {
                labels.push('12 PM');
            } else if (hour > 12) {
                labels.push(`${hour - 12} PM`);
            } else {
                labels.push(`${hour} AM`);
            }
            
            if (hour < 17) {
                labels.push('•', '•', '•');
            }
        }
        return labels;
    }

    async initializeHistoricalData() {
        const now = new Date();
        const currentHour = now.getHours();
        const currentMinute = now.getMinutes();

        // If current time is before 8 AM, don't fetch historical data
        if (currentHour < 8) {
            return;
        }

        // Initialize arrays for each dataset with null values
        const softwareData = Array(37).fill(null);
        const roboticsData = Array(37).fill(null);
        const showroomData = Array(37).fill(null);
        const salesData = Array(37).fill(null);

        // Calculate number of 15-minute intervals to fetch
        const startTime = new Date();
        startTime.setHours(8, 0, 0, 0); // Set to 8 AM today
        
        const endTime = new Date();
        if (currentHour >= 17) {
            endTime.setHours(17, 0, 0, 0);
        }

        // Fetch data for each 15-minute interval
        let currentSlotStart = new Date(startTime);
        while (currentSlotStart < endTime) {
            const slotEnd = new Date(currentSlotStart.getTime() + 15 * 60 * 1000);
            
            try {
                const data = await this.fetchHistoricalData(currentSlotStart, slotEnd);
                if (data?.chart_data) {
                    const slotIndex = this.calculateTimeSlotIndex(currentSlotStart);
                    
                    const zoneIndices = {
                        'software_lab': data.chart_data.labels.indexOf('software_lab'),
                        'robotics_lab': data.chart_data.labels.indexOf('robotics_lab'),
                        'showroom': data.chart_data.labels.indexOf('showroom'),
                        'marketing-&-sales': data.chart_data.labels.indexOf('marketing-&-sales')
                    };

                    // Update data for this time slot
                    softwareData[slotIndex] = data.chart_data.absolute_values[zoneIndices['software_lab']] || 0;
                    roboticsData[slotIndex] = data.chart_data.absolute_values[zoneIndices['robotics_lab']] || 0;
                    showroomData[slotIndex] = data.chart_data.absolute_values[zoneIndices['showroom']] || 0;
                    salesData[slotIndex] = data.chart_data.absolute_values[zoneIndices['marketing-&-sales']] || 0;
                }
            } catch (error) {
                console.error('Error fetching historical data for slot:', error);
            }

            // Move to next 15-minute slot
            currentSlotStart = slotEnd;
        }

        // Update chart with all historical data
        this.chart.data.datasets[0].data = softwareData;
        this.chart.data.datasets[1].data = roboticsData;
        this.chart.data.datasets[2].data = showroomData;
        this.chart.data.datasets[3].data = salesData;

        this.chart.update();
        // console.log('Historical data loaded');
    }

    async fetchHistoricalData(startTime, endTime) {
        try {
            const url = `http://192.168.100.52:8010/analysis/zone-occupancy?start_time=${encodeURIComponent(this.formatDateTime(startTime))}&end_time=${encodeURIComponent(this.formatDateTime(endTime))}`;
            const response = await fetch(url);

            if (!response.ok) {
                throw new Error(`HTTP error! status: ${response.status}`);
            }

            return await response.json();
        } catch (error) {
            console.error('Error fetching historical data:', error);
            return null;
        }
    }

    calculateTimeSlotIndex(time) {
        const hour = time.getHours();
        const minute = time.getMinutes();
        return ((hour - 8) * 4) + Math.floor(minute / 15);
    }

    initializeChart() {
        const ctx = document.getElementById('timePercentageChart').getContext('2d');
        
        // Calculate current time slot for visibility
        const now = new Date();
        const currentSlot = this.calculateTimeSlotIndex(now);
        
        this.chart = new Chart(ctx, {
            type: 'line',
            data: {
                labels: this.generateTimeLabels(),
                datasets: [
                    {
                        label: 'Software Lab',
                        data: Array(37).fill(null),
                        borderColor: '#4CAF50',
                        backgroundColor: 'rgba(76, 175, 80, 0.1)',
                        borderWidth: 2,
                        pointRadius: (context) => {
                            return context.dataIndex <= currentSlot ? 
                                (context.dataIndex % 4 === 0 ? 3 : 1) : 0;
                        },
                        pointBackgroundColor: '#4CAF50',
                        fill: false,
                        tension: 0.4,
                        spanGaps: false
                    },
                    {
                        label: 'Robotics Lab',
                        data: Array(37).fill(null),
                        borderColor: '#2196F3',
                        backgroundColor: 'rgba(33, 150, 243, 0.1)',
                        borderWidth: 2,
                        pointRadius: (context) => {
                            return context.dataIndex <= currentSlot ? 
                                (context.dataIndex % 4 === 0 ? 3 : 1) : 0;
                        },
                        pointBackgroundColor: '#2196F3',
                        fill: false,
                        tension: 0.4,
                        spanGaps: false
                    },
                    {
                        label: 'Showroom',
                        data: Array(37).fill(null),
                        borderColor: '#FFC107',
                        backgroundColor: 'rgba(255, 193, 7, 0.1)',
                        borderWidth: 2,
                        pointRadius: (context) => {
                            return context.dataIndex <= currentSlot ? 
                                (context.dataIndex % 4 === 0 ? 3 : 1) : 0;
                        },
                        pointBackgroundColor: '#FFC107',
                        fill: false,
                        tension: 0.4,
                        spanGaps: false
                    },
                    {
                        label: 'Marketing & Sales',
                        data: Array(37).fill(null),
                        borderColor: '#9C27B0',
                        backgroundColor: 'rgba(156, 39, 176, 0.1)',
                        borderWidth: 2,
                        pointRadius: (context) => {
                            return context.dataIndex <= currentSlot ? 
                                (context.dataIndex % 4 === 0 ? 3 : 1) : 0;
                        },
                        pointBackgroundColor: '#9C27B0',
                        fill: false,
                        tension: 0.4,
                        spanGaps: false
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
                                if (context.parsed.y === null) return null;
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
        
        if (currentHour < 8 || currentHour >= 17) {
            console.log('Outside business hours, skipping update');
            return;
        }

        const endTime = new Date();
        const startTime = new Date(endTime - (15 * 60 * 1000));

        try {
            const data = await this.fetchHistoricalData(startTime, endTime);
            if (data?.chart_data) {
                const dataIndex = this.calculateTimeSlotIndex(now);

                const zoneIndices = {
                    'software_lab': data.chart_data.labels.indexOf('software_lab'),
                    'robotics_lab': data.chart_data.labels.indexOf('robotics_lab'),
                    'showroom': data.chart_data.labels.indexOf('showroom'),
                    'marketing-&-sales': data.chart_data.labels.indexOf('marketing-&-sales')
                };

                // Update only up to the current time slot
                this.chart.data.datasets.forEach((dataset, index) => {
                    // Fill future slots with null
                    for (let i = dataIndex + 1; i < dataset.data.length; i++) {
                        dataset.data[i] = null;
                    }
                });

                // Update the current time slot with new data
                this.chart.data.datasets[0].data[dataIndex] = data.chart_data.absolute_values[zoneIndices['software_lab']] || 0;
                this.chart.data.datasets[1].data[dataIndex] = data.chart_data.absolute_values[zoneIndices['robotics_lab']] || 0;
                this.chart.data.datasets[2].data[dataIndex] = data.chart_data.absolute_values[zoneIndices['showroom']] || 0;
                this.chart.data.datasets[3].data[dataIndex] = data.chart_data.absolute_values[zoneIndices['marketing-&-sales']] || 0;

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
        // console.log('Starting line chart auto-update (15 minute interval)');
        this.updateLatestData();
        this.updateInterval = setInterval(() => {
            this.updateLatestData();
        }, 15 * 60 * 1000); // 15 minutes in milliseconds
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