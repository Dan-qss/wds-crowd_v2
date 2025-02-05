export default class SeriesLineCrowded {
    constructor() {
        this.chart = null;
        this.updateInterval = null;
        this.chartInitialized = false;
        this.canvasId = 'serieslinecrowded';
        this.START_HOUR = 11;
        this.END_HOUR = 20;
        this.SLOTS_PER_HOUR = 30;
        this.TOTAL_SLOTS = (this.END_HOUR - this.START_HOUR) * this.SLOTS_PER_HOUR;

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
                for (let i = 0; i < 29; i++) {
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
            const softwareData = Array(this.TOTAL_SLOTS).fill(null);
            const roboticsData = Array(this.TOTAL_SLOTS).fill(null);
            const showroomData = Array(this.TOTAL_SLOTS).fill(null);
            const salesData = Array(this.TOTAL_SLOTS).fill(null);
            const industrialData = Array(this.TOTAL_SLOTS).fill(null);

            const startTime = new Date();
            startTime.setHours(this.START_HOUR, 0, 0, 0);
            
            const endTime = new Date();
            if (currentHour >= this.END_HOUR) {
                endTime.setHours(this.END_HOUR, 0, 0, 0);
            }

            let currentSlotStart = new Date(startTime);
            while (currentSlotStart < endTime) {
                const slotEnd = new Date(currentSlotStart.getTime() + 120 * 1000);
                
                try {
                    const data = await this.fetchHistoricalData(currentSlotStart, slotEnd);

                    if (data?.chart_data) {
                        const slotIndex = this.calculateTimeSlotIndex(currentSlotStart);
                        
                        const zoneIndices = {
                            'software_lab': data.chart_data.labels.indexOf('software_lab'),
                            'robotics_lab': data.chart_data.labels.indexOf('robotics_lab'),
                            'showroom': data.chart_data.labels.indexOf('showroom'),
                            'marketing-&-sales': data.chart_data.labels.indexOf('marketing-&-sales'),
                            'industrial_robot': data.chart_data.labels.indexOf('industrial_robot')
                        };

                        if (slotIndex >= 0 && slotIndex < softwareData.length) {
                            softwareData[slotIndex] = data.chart_data.absolute_values[zoneIndices['software_lab']] || 0;
                            roboticsData[slotIndex] = data.chart_data.absolute_values[zoneIndices['robotics_lab']] || 0;
                            showroomData[slotIndex] = data.chart_data.absolute_values[zoneIndices['showroom']] || 0;
                            salesData[slotIndex] = data.chart_data.absolute_values[zoneIndices['marketing-&-sales']] || 0;
                            industrialData[slotIndex] = data.chart_data.absolute_values[zoneIndices['industrial_robot']] || 0;
                        }
                    }
                } catch (error) {
                    console.error('Error fetching historical data for slot:', error);
                }

                currentSlotStart = slotEnd;
            }

            if (this.chart && this.chart.data && this.chart.data.datasets) {
                this.chart.data.datasets[0].data = softwareData;
                this.chart.data.datasets[1].data = roboticsData;
                this.chart.data.datasets[2].data = showroomData;
                this.chart.data.datasets[3].data = salesData;
                this.chart.data.datasets[4].data = industrialData;

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
        return ((hour - this.START_HOUR) * this.SLOTS_PER_HOUR) + Math.floor(minute / 2);
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
                            label: 'Drones',
                            data: Array(this.TOTAL_SLOTS).fill(null),
                            borderColor: '#4CAF50',
                            backgroundColor: 'rgba(76, 175, 80, 0.1)',
                            borderWidth: 2,
                            fill: true,
                            pointRadius: 0,
                            pointHoverRadius: 4
                        },
                        {
                            label: 'Barista Robot',
                            data: Array(this.TOTAL_SLOTS).fill(null),
                            borderColor: '#2196F3',
                            backgroundColor: 'rgba(33, 150, 243, 0.1)',
                            borderWidth: 2,
                            fill: true,
                            pointRadius: 0,
                            pointHoverRadius: 4
                        },
                        {
                            label: 'Mosaed Robot',
                            data: Array(this.TOTAL_SLOTS).fill(null),
                            borderColor: '#FFD93D',
                            backgroundColor: 'rgba(255, 217, 61, 0.1)',
                            borderWidth: 2,
                            fill: true,
                            pointRadius: 0,
                            pointHoverRadius: 4
                        },
                        {
                            label: 'AMR',
                            data: Array(this.TOTAL_SLOTS).fill(null),
                            borderColor: '#9C27B0',
                            backgroundColor: 'rgba(156, 39, 176, 0.1)',
                            borderWidth: 2,
                            fill: true,
                            pointRadius: 0,
                            pointHoverRadius: 4
                        },
                        {
                            label: 'Industrial Robot',
                            data: Array(this.TOTAL_SLOTS).fill(null),
                            borderColor: '#FF5722',
                            backgroundColor: 'rgba(255, 87, 34, 0.1)',
                            borderWidth: 2,
                            fill: true,
                            pointRadius: 0,
                            pointHoverRadius: 4
                        }
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
                                    const minutes = (dataIndex % 30) * 2;
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
                                        const hour = 11 + Math.floor(index / 30);
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
            const url = `http://192.168.100.219:8010/analysis/zone-occupancy?start_time=${encodeURIComponent(this.formatDateTime(startTime))}&end_time=${encodeURIComponent(this.formatDateTime(endTime))}`;
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
            const startTime = new Date(endTime - (120 * 1000));

            const data = await this.fetchHistoricalData(startTime, endTime);
            if (data?.chart_data) {
                const dataIndex = this.calculateTimeSlotIndex(now);

                const zoneIndices = {
                    'software_lab': data.chart_data.labels.indexOf('software_lab'),
                    'robotics_lab': data.chart_data.labels.indexOf('robotics_lab'),
                    'showroom': data.chart_data.labels.indexOf('showroom'),
                    'marketing-&-sales': data.chart_data.labels.indexOf('marketing-&-sales'),
                    'industrial_robot': data.chart_data.labels.indexOf('industrial_robot')
                };

                this.chart.data.datasets.forEach((dataset, index) => {
                    for (let i = dataIndex + 1; i < dataset.data.length; i++) {
                        dataset.data[i] = null;
                    }
                });

                this.chart.data.datasets[0].data[dataIndex] = data.chart_data.absolute_values[zoneIndices['software_lab']] || 0;
                this.chart.data.datasets[1].data[dataIndex] = data.chart_data.absolute_values[zoneIndices['robotics_lab']] || 0;
                this.chart.data.datasets[2].data[dataIndex] = data.chart_data.absolute_values[zoneIndices['showroom']] || 0;
                this.chart.data.datasets[3].data[dataIndex] = data.chart_data.absolute_values[zoneIndices['marketing-&-sales']] || 0;
                this.chart.data.datasets[4].data[dataIndex] = data.chart_data.absolute_values[zoneIndices['industrial_robot']] || 0;

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
        }, 120 * 1000);
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