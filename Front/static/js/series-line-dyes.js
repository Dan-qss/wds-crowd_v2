export default class SeriesLineDays {
    constructor() {
        this.chart = null;
        this.updateInterval = null;
        this.chartInitialized = false;
        this.canvasId = 'serieslinedays';
        this.START_HOUR = 12;  // 12 PM
        this.END_HOUR = 21;    // 9 PM
        this.SLOTS_PER_HOUR = 30; // Changed to 30 for 2-minute intervals
        this.TOTAL_SLOTS = (this.END_HOUR - this.START_HOUR) * this.SLOTS_PER_HOUR;
        this.totalAvHistory = Array(this.TOTAL_SLOTS).fill(null);

        this.initializeChart().then(() => {
            this.initializeHistoricalData();
            this.startAutoUpdate();
        }).catch(error => {
            console.error('Failed to initialize chart:', error);
        });
    }

    generateTimeLabels() {
        const labels = [];
        for (let hour = this.START_HOUR; hour <= this.END_HOUR; hour++) {
            if (hour === 12) {
                labels.push('12 PM');
            } else if (hour > 12) {
                labels.push(`${hour - 12} PM`);
            } else {
                labels.push(`${hour} AM`);
            }
            
            if (hour < this.END_HOUR) {
                for (let i = 0; i < 29; i++) { // Changed to 29 for 2-minute intervals
                    labels.push('');
                }
            }
        }
        return labels;
    }

    async initializeHistoricalData() {
        if (!this.chartInitialized || !this.chart) {
            console.error('Cannot initialize historical data: Chart not initialized');
            return;
        }

        const now = new Date();
        const currentHour = now.getHours();

        if (currentHour < this.START_HOUR) {
            console.log('Before business hours, skipping historical data load');
            return;
        }

        try {
            const startTime = new Date();
            startTime.setHours(this.START_HOUR, 0, 0, 0);
            
            const endTime = new Date();
            if (currentHour >= this.END_HOUR) {
                endTime.setHours(this.END_HOUR, 0, 0, 0);
            }

            // Fetch data for each 2-minute interval
            let currentSlotStart = new Date(startTime);
            while (currentSlotStart < endTime) {
                const slotEnd = new Date(currentSlotStart.getTime() + 120 * 1000); // Changed to 2 minutes
                
                try {
                    const data = await this.fetchHistoricalData(currentSlotStart, slotEnd);
                    if (data.zone_data) {
                        const totalPeople = data.zone_data.reduce((sum, zone) => sum + parseFloat(zone.total_people), 0);
                        const maxCapacity = 30; // Set your maximum capacity here
                        const totalOccupancyPercentage = (totalPeople / maxCapacity) * 100;
                        data.totalOccupancy = {
                            totalPeople: totalPeople.toFixed(2),
                            maxCapacity,
                            percentage: totalOccupancyPercentage.toFixed(2)
                        };
                    
                        // Calculate the average percentage based on total people and max capacity
                        const totalAv = totalOccupancyPercentage.toFixed(2);
                        const slotIndex = this.calculateTimeSlotIndex(currentSlotStart);
                        
                        if (slotIndex >= 0 && slotIndex < this.totalAvHistory.length) {
                            this.totalAvHistory[slotIndex] = parseFloat(totalAv);
                        }
                    }
                } catch (error) {
                    console.error('Error fetching historical data for slot:', error);
                }

                currentSlotStart = slotEnd;
            }

            if (this.chart && this.chart.data && this.chart.data.datasets) {
                this.chart.data.datasets[0].data = this.totalAvHistory;
                this.chart.update();
            }
        } catch (error) {
            console.error('Error loading historical data:', error);
        }
    }

    calculateTimeSlotIndex(time) {
        const hour = time.getHours();
        const minute = time.getMinutes();
        if (hour < this.START_HOUR) return -1;
        if (hour >= this.END_HOUR) return this.TOTAL_SLOTS;
        return ((hour - this.START_HOUR) * this.SLOTS_PER_HOUR) + Math.floor(minute / 2); // Changed to floor(minute/2) for 2-minute intervals
    }

    async initializeChart() {
        try {
            const canvas = document.getElementById(this.canvasId);
            if (!canvas) {
                throw new Error(`Canvas element with id '${this.canvasId}' not found`);
            }

            const ctx = canvas.getContext('2d');
            if (!ctx) {
                throw new Error('Failed to get canvas context');
            }
            
            this.chart = new Chart(ctx, {
                type: 'line',
                data: {
                    labels: this.generateTimeLabels(),
                    datasets: [
                        {
                            label: '8 Feb 2025',
                            data: Array(this.TOTAL_SLOTS).fill(null),
                            borderColor: '#FF0000',
                            backgroundColor: 'rgba(255, 0, 0, 0.1)',
                            borderWidth: 2,
                            fill: true,
                            pointRadius: 0,
                            pointHoverRadius: 4
                        },
                    ]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    plugins: {
                        legend: {
                            position: 'top',
                            align: 'end',
                            labels: {
                                color: '#fff',
                                font: {
                                    size: 10
                                }
                            }
                        },
                        tooltip: {
                            mode: 'index',
                            intersect: false,
                            backgroundColor: 'rgba(0, 0, 0, 0.7)',
                            callbacks: {
                                title: (context) => {
                                    const dataIndex = context[0].dataIndex;
                                    const hour = Math.floor(dataIndex / 30) + this.START_HOUR;
                                    const minutes = (dataIndex % 30) * 2; // Changed for 2-minute intervals
                                    const period = hour >= 12 ? 'PM' : 'AM';
                                    const displayHour = hour > 12 ? hour - 12 : hour;
                                    return `${displayHour}:${minutes.toString().padStart(2, '0')} ${period}`;
                                },
                                label: (context) => {
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
                            grid: {
                                color: 'rgba(255, 255, 255, 0.1)'
                            },
                            ticks: {
                                color: '#fff',
                                callback: value => `${value}%`
                            }
                        },
                        x: {
                            grid: {
                                display: false
                            },
                            ticks: {
                                color: '#fff',
                                maxRotation: 0,
                                autoSkip: false,
                                callback: (value, index) => {
                                    if (index % 30 === 0) {
                                        const hour = Math.floor(index / 30) + this.START_HOUR;
                                        if (hour === 12) return '12 PM';
                                        return hour > 12 ? `${hour - 12} PM` : `${hour} AM`;
                                    }
                                    return '';
                                },
                                font: {
                                    size: 10
                                }
                            }
                        }
                    },
                    elements: {
                        line: {
                            tension: 0.4
                        }
                    }
                }
            });

            this.chartInitialized = true;
            return this.chart;
        } catch (error) {
            console.error('Error initializing chart:', error);
            throw error;
        }
    }

    async fetchHistoricalData(startTime, endTime) {
        try {
            const url = `http://192.168.8.15:8010/analysis/zone-occupancy?start_time=${encodeURIComponent(this.formatDateTime(startTime))}&end_time=${encodeURIComponent(this.formatDateTime(endTime))}`;

            const response = await fetch(url);

            if (!response.ok) {
                throw new Error(`HTTP error! status: ${response.status}`);
            }

            const data = await response.json();
            return data;
        } catch (error) {
            console.error('Error fetching historical data:', error);
            return null;
        }
    }

    async updateLatestData() {
        if (!this.chartInitialized || !this.chart) {
            console.error('Cannot update data: Chart not initialized');
            return;
        }

        const now = new Date();
        const currentHour = now.getHours();
        
        if (currentHour < this.START_HOUR || currentHour >= this.END_HOUR) {
            console.log('Outside business hours, skipping update');
            return;
        }

        try {
            const endTime = new Date();
            const startTime = new Date(endTime - (120 * 1000)); // Changed to 2 minutes

            const data = await this.fetchHistoricalData(startTime, endTime);
            if (data?.zone_data) {
                const dataIndex = this.calculateTimeSlotIndex(now);

                const totalPeople = data.zone_data.reduce((sum, zone) => sum + parseFloat(zone.total_people), 0);
                const maxCapacity = 30;
                const totalOccupancyPercentage = (totalPeople / maxCapacity) * 100;
                const totalAv = totalOccupancyPercentage.toFixed(2);
                console.log("maxCapacity=", maxCapacity)
                console.log("totalPeople=", totalPeople)
                console.log("totalAv=", maxCapacity)


                // Clear future data points
                for (let i = dataIndex + 1; i < this.totalAvHistory.length; i++) {
                    this.totalAvHistory[i] = null;
                }

                // Update the current data point
                if (dataIndex >= 0 && dataIndex < this.totalAvHistory.length) {
                    this.totalAvHistory[dataIndex] = parseFloat(totalAv);
                }

                // Update chart
                this.chart.data.datasets[0].data = this.totalAvHistory;
                this.chart.update('none');
            }
        } catch (error) {
            console.error('Error updating chart:', error);
        }
    }

    formatDateTime(date) {
        const pad = (num) => String(num).padStart(2, '0');
        return `${date.getFullYear()}-${pad(date.getMonth() + 1)}-${pad(date.getDate())} ${pad(date.getHours())}:${pad(date.getMinutes())}:${pad(date.getSeconds())}`;
    }

    startAutoUpdate() {
        if (!this.chartInitialized) {
            console.error('Cannot start auto-update: Chart not initialized');
            return;
        }

        this.updateLatestData();
        this.updateInterval = setInterval(() => {
            this.updateLatestData();
        }, 60 * 1000); // Update every 2 minutes
    }

    destroy() {
        if (this.updateInterval) {
            clearInterval(this.updateInterval);
            this.updateInterval = null;
        }
        if (this.chart) {
            this.chart.destroy();
            this.chart = null;
        }
        this.chartInitialized = false;
    }
}