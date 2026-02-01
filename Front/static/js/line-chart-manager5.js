export default class ChartManager {
    constructor() {
        this.chart = null;
        this.updateInterval = null;
        this.initializeChart();
        this.initializeFakeHistoricalData(); // Changed to fake data
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

    // Generate realistic fake data patterns with zone-specific behaviors
    generateFakeDataPattern(zone, timeSlot) {
        const hour = Math.floor(timeSlot / 4) + 8;
        const minute = (timeSlot % 4) * 15;
        const timeProgress = timeSlot / 36; // 0 to 1 throughout the day
        
        let value = 0;
        
        // Different patterns for each zone
        switch(zone) {
            case 'software':
                // Software devs: slow start, peak mid-morning, dip at lunch, afternoon focus
                if (hour < 9) value = 15 + Math.random() * 20; // Slow start
                else if (hour < 12) value = 50 + Math.sin(timeProgress * Math.PI) * 30; // Morning peak
                else if (hour === 12) value = 25 + Math.random() * 15; // Lunch dip
                else if (hour < 15) value = 60 + Math.sin(timeProgress * Math.PI * 2) * 25; // Afternoon productivity
                else value = 40 + Math.random() * 25; // Wind down
                break;
                
            case 'robotics':
                // Robotics: steady build-up, peak in afternoon when hardware testing
                if (hour < 10) value = 20 + timeProgress * 30;
                else if (hour < 13) value = 35 + Math.cos(timeProgress * Math.PI) * 20;
                else if (hour < 16) value = 55 + Math.sin((hour - 13) * Math.PI) * 30; // Afternoon testing peak
                else value = 35 + Math.random() * 20;
                break;
                
            case 'showroom':
                // Showroom: visitor-driven, peaks when external meetings/demos
                const meetingTimes = [10, 11.5, 14, 15.5]; // Common demo times
                let nearMeeting = false;
                for (let meetingTime of meetingTimes) {
                    if (Math.abs(hour + minute/60 - meetingTime) < 0.5) {
                        nearMeeting = true;
                        break;
                    }
                }
                if (nearMeeting) value = 40 + Math.random() * 40; // Demo peaks
                else if (hour === 12) value = 10 + Math.random() * 15; // Lunch quiet
                else value = 15 + Math.random() * 25; // Generally quieter
                break;
                
            case 'sales':
                // Sales: meeting-heavy, strong morning and afternoon peaks
                if (hour < 9) value = 30 + Math.random() * 20; // Early calls
                else if (hour < 12) value = 50 + Math.sin(timeProgress * Math.PI * 1.5) * 35; // Morning meetings
                else if (hour === 12) value = 20 + Math.random() * 20; // Lunch meetings
                else if (hour < 16) value = 45 + Math.cos(timeProgress * Math.PI) * 30; // Afternoon calls
                else value = 35 + Math.random() * 25;
                break;
        }
        
        // Add realistic fluctuation
        const fluctuation = 1 + (Math.random() - 0.5) * 0.4;
        value *= fluctuation;
        
        // Ensure reasonable bounds
        return Math.max(5, Math.min(85, value));
    }

    async initializeFakeHistoricalData() {
        const now = new Date();
        const currentHour = now.getHours();
        const currentMinute = now.getMinutes();

        // If current time is before 8 AM, don't add any data
        if (currentHour < 8) {
            return;
        }

        // Initialize arrays with null values
        const softwareData = Array(37).fill(null);
        const roboticsData = Array(37).fill(null);
        const showroomData = Array(37).fill(null);
        const salesData = Array(37).fill(null);

        // Generate data from 8 AM to current time (or end of business day)
        const currentSlot = this.calculateCurrentTimeSlot();
        const endSlot = Math.max(0, Math.min(36, currentSlot)); // Up to current time or 5 PM
        
        for (let slot = 0; slot <= endSlot; slot++) {
            softwareData[slot] = this.generateFakeDataPattern('software', slot);
            roboticsData[slot] = this.generateFakeDataPattern('robotics', slot);
            showroomData[slot] = this.generateFakeDataPattern('showroom', slot);
            salesData[slot] = this.generateFakeDataPattern('sales', slot);
        }

        // Update chart with fake data
        this.chart.data.datasets[0].data = softwareData;
        this.chart.data.datasets[1].data = roboticsData;
        this.chart.data.datasets[2].data = showroomData;
        this.chart.data.datasets[3].data = salesData;

        this.chart.update();
        console.log('Fake historical data loaded from 8 AM to current time');
    }

    calculateCurrentTimeSlot() {
        const now = new Date();
        const hour = now.getHours();
        const minute = now.getMinutes();
        
        if (hour < 8) return -1;
        if (hour >= 17) return 36; // End of day
        
        return ((hour - 8) * 4) + Math.floor(minute / 15);
    }

    async fetchHistoricalData(startTime, endTime) {
        try {
            const url = `http://192.168.100.65:8010/analysis/zone-occupancy?start_time=${encodeURIComponent(this.formatDateTime(startTime))}&end_time=${encodeURIComponent(this.formatDateTime(endTime))}`;
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
        // For demo purposes, just generate new fake data for the current time slot
        const now = new Date();
        const currentHour = now.getHours();
        const currentMinute = now.getMinutes();
        
        if (currentHour < 8 || currentHour >= 17) {
            console.log('Outside business hours, skipping update');
            return;
        }

        const dataIndex = this.calculateTimeSlotIndex(now);
        
        // Generate fresh fake data for current slot (if within business hours)
        if (dataIndex >= 0 && dataIndex <= 36) {
            // Generate fresh fake data for current slot
            this.chart.data.datasets[0].data[dataIndex] = this.generateFakeDataPattern('software', dataIndex);
            this.chart.data.datasets[1].data[dataIndex] = this.generateFakeDataPattern('robotics', dataIndex);
            this.chart.data.datasets[2].data[dataIndex] = this.generateFakeDataPattern('showroom', dataIndex);
            this.chart.data.datasets[3].data[dataIndex] = this.generateFakeDataPattern('sales', dataIndex);

            this.chart.update();
            console.log(`Chart updated with fake data for ${currentHour}:${currentMinute.toString().padStart(2, '0')}`);
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