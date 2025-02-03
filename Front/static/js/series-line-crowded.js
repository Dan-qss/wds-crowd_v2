export default class SeriesLineCrowded {
    constructor() {
        this.chart = null;
        this.updateInterval = null;
        this.useMockData = false;
        this.apiFailCount = 0;
        this.initializeChart();
        this.startAutoUpdate();
    }

    generateTimeLabels() {
        const labels = [];
        for (let hour = 11; hour <= 21; hour++) { 
            if (hour === 12) {
                labels.push('12 PM');
            } else if (hour > 12) {
                labels.push(`${hour - 12} PM`);
            } else {
                labels.push(`${hour} AM`);
            }
            
            if (hour < 21) {
                for (let i = 0; i < 11; i++) {
                    labels.push('');
                }
            }
        }
        return labels;
    }

    async fetchHistoricalData(startTime, endTime) {
        try {
            const url = `http://192.168.100.219:8010/analysis/zone-occupancy?start_time=${encodeURIComponent(this.formatDateTime(startTime))}&end_time=${encodeURIComponent(this.formatDateTime(endTime))}`;
            const response = await fetch(url);

            if (!response.ok) {
                throw new Error(`HTTP error! status: ${response.status}`);
            }

            return await response.json();
        } catch (error) {
            console.error('Error fetching historical data:', error);
            this.apiFailCount++;
            if (this.apiFailCount >= 3) {
                this.useMockData = true;
                console.log('Switching to mock data due to API failures');
            }
            return null;
        }
    }

    formatDateTime(date) {
        const pad = (num) => String(num).padStart(2, '0');
        return `${date.getFullYear()}-${pad(date.getMonth() + 1)}-${pad(date.getDate())} ${pad(date.getHours())}:${pad(date.getMinutes())}:${pad(date.getSeconds())}`;
    }

    async initializeHistoricalData() {
        const now = new Date();
        const currentHour = now.getHours();

        if (currentHour < 11) return;

        const startTime = new Date();
        startTime.setHours(11, 0, 0, 0);
        
        const endTime = new Date();
        if (currentHour >= 21) {
            endTime.setHours(21, 0, 0, 0);
        }

        if (!this.useMockData) {
            try {
                const data = await this.fetchHistoricalData(startTime, endTime);
                if (data?.chart_data) {
                    // Process historical data from API
                    return this.processApiData(data);
                }
            } catch (error) {
                console.error('Error fetching initial historical data:', error);
                this.useMockData = true;
            }
        }

        // Fallback to mock data if API fails
        return this.generateMockHistoricalData();
    }

    processApiData(data) {
        const zoneIndices = {
            'software_lab': data.chart_data.labels.indexOf('software_lab'),
            'robotics_lab': data.chart_data.labels.indexOf('robotics_lab'),
            'showroom': data.chart_data.labels.indexOf('showroom'),
            'marketing-&-sales': data.chart_data.labels.indexOf('marketing-&-sales'),
            'zone': data.chart_data.labels.indexOf('zone')
        };

        return {
            software: data.chart_data.absolute_values[zoneIndices['software_lab']] || 0,
            robotics: data.chart_data.absolute_values[zoneIndices['robotics_lab']] || 0,
            showroom: data.chart_data.absolute_values[zoneIndices['showroom']] || 0,
            sales: data.chart_data.absolute_values[zoneIndices['marketing-&-sales']] || 0,
            zone: data.chart_data.absolute_values[zoneIndices['zone']] || 0
        };
    }

    initializeChart() {
        const canvas = document.getElementById('serieslinecrowded');
        if (!canvas) {
            console.error('Series line chart canvas element not found');
            return;
        }

        const ctx = canvas.getContext('2d');
        const now = new Date();
        const currentSlot = this.calculateTimeSlotIndex(now);

        const historicalData = this.generateMockHistoricalData();
        
        this.chart = new Chart(ctx, {
            type: 'line',
            data: {
                labels: this.generateTimeLabels(),
                datasets: [
                    {
                        label: 'Software Lab',
                        data: historicalData.software.map((value, index) => 
                            index <= currentSlot ? value : null),
                        borderColor: '#4CAF50',
                        backgroundColor: 'rgba(76, 175, 80, 0.1)',
                        borderWidth: 2,
                        fill: true,
                        pointRadius: 0,
                        pointHoverRadius: 3
                    },
                    {
                        label: 'Robotics Lab',
                        data: historicalData.robotics.map((value, index) => 
                            index <= currentSlot ? value : null),
                        borderColor: '#2196F3',
                        backgroundColor: 'rgba(33, 150, 243, 0.1)',
                        borderWidth: 2,
                        fill: true,
                        pointRadius: 0,
                        pointHoverRadius: 3
                    },
                    {
                        label: 'Showroom',
                        data: historicalData.showroom.map((value, index) => 
                            index <= currentSlot ? value : null),
                        borderColor: '#FFC107',
                        backgroundColor: 'rgba(255, 193, 7, 0.1)',
                        borderWidth: 2,
                        fill: true,
                        pointRadius: 0,
                        pointHoverRadius: 3
                    },
                    {
                        label: 'Marketing & Sales',
                        data: historicalData.sales.map((value, index) => 
                            index <= currentSlot ? value : null),
                        borderColor: '#9C27B0',
                        backgroundColor: 'rgba(156, 39, 176, 0.1)',
                        borderWidth: 2,
                        fill: true,
                        pointRadius: 0,
                        pointHoverRadius: 3
                    },
                    {
                        label: 'Zone',
                        data: historicalData.zone.map((value, index) => 
                            index <= currentSlot ? value : null),
                        borderColor: '#FF5722',
                        backgroundColor: 'rgba(255, 87, 34, 0.1)',
                        borderWidth: 2,
                        fill: true,
                        pointRadius: 0,
                        pointHoverRadius: 3
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
                                const hour = Math.floor(dataIndex / 12) + 11;
                                const minutes = (dataIndex % 12) * 5;
                                const period = hour >= 12 ? 'PM' : 'AM';
                                const displayHour = hour > 12 ? hour - 12 : hour;
                                return `${displayHour}:${minutes.toString().padStart(2, '0')} ${period}`;
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
                            callback: (value, index) => {
                                return index % 12 === 0 ? this.generateTimeLabels()[index] : '';
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
    }

    generateMockHistoricalData() {
        const generateSmoothData = () => {
            const data = [];
            let value = Math.random() * 30 + 40;
            for (let i = 0; i < 121; i++) {
                value += (Math.random() - 0.5) * 10;
                value = Math.min(Math.max(value, 0), 100);
                data.push(value);
            }
            return data;
        };

        return {
            software: generateSmoothData(),
            robotics: generateSmoothData(),
            showroom: generateSmoothData(),
            sales: generateSmoothData(),
            zone: generateSmoothData()
        };
    }

    calculateTimeSlotIndex(time) {
        const hour = time.getHours();
        const minute = time.getMinutes();
        if (hour < 11) return -1;
        if (hour >= 21) return 120;
        return ((hour - 11) * 12) + Math.floor(minute / 5);
    }

    async updateLatestData() {
        const now = new Date();
        const currentHour = now.getHours();
        
        if (currentHour < 11 || currentHour >= 21) return;

        const currentSlot = this.calculateTimeSlotIndex(now);

        if (!this.useMockData) {
            try {
                const endTime = new Date();
                const startTime = new Date(endTime - (5 * 60 * 1000));
                const data = await this.fetchHistoricalData(startTime, endTime);
                
                if (data?.chart_data) {
                    const zoneIndices = {
                        'software_lab': data.chart_data.labels.indexOf('software_lab'),
                        'robotics_lab': data.chart_data.labels.indexOf('robotics_lab'),
                        'showroom': data.chart_data.labels.indexOf('showroom'),
                        'marketing-&-sales': data.chart_data.labels.indexOf('marketing-&-sales'),
                        'zone': data.chart_data.labels.indexOf('zone')
                    };

                    this.chart.data.datasets[0].data[currentSlot] = data.chart_data.absolute_values[zoneIndices['software_lab']] || 0;
                    this.chart.data.datasets[1].data[currentSlot] = data.chart_data.absolute_values[zoneIndices['robotics_lab']] || 0;
                    this.chart.data.datasets[2].data[currentSlot] = data.chart_data.absolute_values[zoneIndices['showroom']] || 0;
                    this.chart.data.datasets[3].data[currentSlot] = data.chart_data.absolute_values[zoneIndices['marketing-&-sales']] || 0;
                    this.chart.data.datasets[4].data[currentSlot] = data.chart_data.absolute_values[zoneIndices['zone']] || 0;
                } else {
                    throw new Error('Invalid API response');
                }
            } catch (error) {
                console.error('API error, falling back to mock data:', error);
                this.useMockData = true;
            }
        }

        // If API failed or we're using mock data, generate mock values
        if (this.useMockData) {
            this.chart.data.datasets.forEach(dataset => {
                const lastValue = dataset.data[currentSlot - 1] || 50;
                const newValue = Math.max(0, Math.min(100,
                    lastValue + (Math.random() - 0.5) * 10
                ));
                dataset.data[currentSlot] = newValue;
            });
        }

        // Clear future values
        this.chart.data.datasets.forEach(dataset => {
            for (let i = currentSlot + 1; i < dataset.data.length; i++) {
                dataset.data[i] = null;
            }
        });
        
        this.chart.update('none');
    }

    startAutoUpdate() {
        this.updateInterval = setInterval(() => {
            this.updateLatestData();
        }, 300000); // 5 minutes
        
        this.updateLatestData();
    }

    destroy() {
        if (this.updateInterval) {
            clearInterval(this.updateInterval);
        }
        if (this.chart) {
            this.chart.destroy();
        }
    }
}