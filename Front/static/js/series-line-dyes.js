export default class SeriesLineCrowded {
    constructor() {
        this.chart = null;
        this.updateInterval = null;
        this.useMockData = true;
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

    generateMockData() {
        const data = [];
        let value = 30 + Math.random() * 20; // Start between 30-50
        
        for (let i = 0; i < 121; i++) { // Adjusted for 11 AM start
            if (i < 24) { // 11AM - 1PM
                value += (Math.random() - 0.3) * 8;
            } else if (i > 72) { // After 5PM
                value += (Math.random() - 0.6) * 8;
            } else { // Regular hours
                value += (Math.random() - 0.5) * 6;
            }
            
            value = Math.min(Math.max(value, 0), 100);
            data.push(value);
        }
        
        return data;
    }

    initializeChart() {
        const canvas = document.getElementById('serieslinedays');
        if (!canvas) {
            console.error('Series line chart canvas element not found');
            return;
        }

        const ctx = canvas.getContext('2d');
        
        this.chart = new Chart(ctx, {
            type: 'line',
            data: {
                labels: this.generateTimeLabels(),
                datasets: [
                    {
                        label: '9 Feb 2025',
                        data: this.generateMockData(),
                        borderColor: '#FF6B6B',  // Coral Red
                        backgroundColor: 'rgba(255, 107, 107, 0.1)',
                        borderWidth: 2,
                        fill: true,
                        pointRadius: 0,
                        pointHoverRadius: 4
                    },
                    {
                        label: '10 Feb 2025',
                        data: this.generateMockData(),
                        borderColor: '#4ECDC4',  // Turquoise
                        backgroundColor: 'rgba(78, 205, 196, 0.1)',
                        borderWidth: 2,
                        fill: true,
                        pointRadius: 0,
                        pointHoverRadius: 4
                    },
                    {
                        label: '11 Feb 2025',
                        data: this.generateMockData(),
                        borderColor: '#FFD93D',  // Golden Yellow
                        backgroundColor: 'rgba(255, 217, 61, 0.1)',
                        borderWidth: 2,
                        fill: true,
                        pointRadius: 0,
                        pointHoverRadius: 4
                    },
                    {
                        label: '12 Feb 2025',
                        data: this.generateMockData(),
                        borderColor: '#6C5CE7',  // Soft Purple
                        backgroundColor: 'rgba(108, 92, 231, 0.1)',
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
                                const hour = Math.floor(dataIndex / 12) + 11;
                                const minutes = (dataIndex % 12) * 5;
                                const period = hour >= 12 ? 'PM' : 'AM';
                                const displayHour = hour > 12 ? hour - 12 : hour;
                                return `${displayHour}:${minutes.toString().padStart(2, '0')} ${period}`;
                            },
                            label: (context) => {
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

    calculateTimeSlotIndex(time) {
        const hour = time.getHours();
        const minute = time.getMinutes();
        if (hour < 11) return -1;
        if (hour >= 21) return 120;
        return ((hour - 11) * 12) + Math.floor(minute / 5);
    }

    updateLatestData() {
        const now = new Date();
        const currentSlot = this.calculateTimeSlotIndex(now);
        
        if (currentSlot >= 0 && currentSlot < 121) {
            this.chart.data.datasets.forEach(dataset => {
                const lastValue = dataset.data[currentSlot - 1] || 50;
                const newValue = Math.max(0, Math.min(100,
                    lastValue + (Math.random() - 0.5) * 8
                ));
                dataset.data[currentSlot] = newValue;

                // Clear future values
                for (let i = currentSlot + 1; i < dataset.data.length; i++) {
                    dataset.data[i] = null;
                }
            });
            
            this.chart.update('none');
        }
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