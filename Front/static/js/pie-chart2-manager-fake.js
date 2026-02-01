export default class PieChart2Manager {
    constructor() {
        this.chart = null;
        this.updateInterval = null;
        this.initializeChart();
        this.startAutoUpdate();
        // console.log('PieChart2Manager initialized');
    }

    initializeChart() {
        const canvas = document.getElementById('pieChart2');
        if (!canvas) {
            console.error('Pie chart 2 canvas element not found');
            return;
        }

        const ctx = canvas.getContext('2d');
        console.log('Canvas context obtained');
        
        this.chart = new Chart(ctx, {
            type: 'doughnut',
            data: {
                labels: ['Software Lab', 'Robotics Lab', 'Showroom', 'Marketing & Sales'],
                datasets: [{
                    data: [0, 0, 0, 0],
                    backgroundColor: [
                        '#4CAF50',    // Green
                        '#2196F3',    // Blue
                        '#FFC107',    // Yellow
                        '#9C27B0'     // Purple
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
                        left: 5,
                        right: 5,
                        top: 5,
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
                            padding: 10,
                            font: {
                                size: 10,
                                family: "'Segoe UI', sans-serif"
                            },
                            color: '#fff',
                            generateLabels: function(chart) {
                                const data = chart.data;
                                return data.labels.map((label, i) => ({
                                    text: `${label} ${data.datasets[0].data[i].toFixed(1)}%`,
                                    fillStyle: data.datasets[0].backgroundColor[i],
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
                            size: 11,
                            color: '#fff'
                        },
                        bodyFont: {
                            size: 11,
                            color: '#fff'
                        },
                        padding: 10,
                        callbacks: {
                            label: function(context) {
                                return `${context.label}: ${context.parsed.toFixed(1)}%`;
                            }
                        },
                        titleColor: '#fff',
                        bodyColor: '#fff'
                    }
                }
            }
        });
    }

    // Generate current fake data based on time of day
    generateCurrentFakeData() {
        const now = new Date();
        const hour = now.getHours();
        const minute = now.getMinutes();
        
        // Calculate current time slot (same as line chart)
        const timeSlot = ((hour - 8) * 4) + Math.floor(minute / 15);
        
        // Use the same pattern generation as the line chart
        const software = this.generateFakeDataPattern('software', timeSlot);
        const robotics = this.generateFakeDataPattern('robotics', timeSlot);
        const showroom = this.generateFakeDataPattern('showroom', timeSlot);
        const sales = this.generateFakeDataPattern('sales', timeSlot);
        
        return {
            software,
            robotics,
            showroom,
            sales
        };
    }

    // Same pattern generation as line chart for consistency
    generateFakeDataPattern(zone, timeSlot) {
        const hour = Math.floor(timeSlot / 4) + 8;
        const minute = (timeSlot % 4) * 15;
        const timeProgress = timeSlot / 36; // 0 to 1 throughout the day
        
        let value = 0;
        
        // Different patterns for each zone (same as line chart)
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

    async updateLatestData() {
        const now = new Date();
        const currentHour = now.getHours();
        
        // Only update during business hours (8 AM - 5 PM)
        if (currentHour < 8 || currentHour >= 17) {
            console.log('Outside business hours, showing minimal activity');
            // Show minimal activity outside business hours
            this.updateData({
                software: 5 + Math.random() * 10,
                robotics: 3 + Math.random() * 8,
                showroom: 2 + Math.random() * 5,
                sales: 4 + Math.random() * 8
            });
            return;
        }
// TEST
        // Generate fake data instead of fetching from API
        try {
            const fakeData = this.generateCurrentFakeData();
            console.log(`Pie chart updated with fake data for ${currentHour}:${now.getMinutes().toString().padStart(2, '0')}`);
            this.updateData(fakeData);
        } catch (error) {
            console.error('Error generating fake data:', error);
        }
    }

    startAutoUpdate() {
        // Initial update
        this.updateLatestData();

        // Set up interval for updates every 2 seconds
        this.updateInterval = setInterval(() => {
            this.updateLatestData();
        }, 2000); // 2 seconds
    }

    stopAutoUpdate() {
        if (this.updateInterval) {
            clearInterval(this.updateInterval);
            this.updateInterval = null;
            console.log('Auto-update stopped');
        }
    }

    updateData(data) {
        if (this.chart) {
            this.chart.data.datasets[0].data = [
                data.software,
                data.robotics,
                data.showroom,
                data.sales
            ];
            this.chart.update();
        }
    }

    handleWebSocketData(data) {
        if (data && data.software !== undefined && data.robotics !== undefined && 
            data.showroom !== undefined && data.sales !== undefined) {
            this.updateData(data);
        }
    }

    destroy() {
        this.stopAutoUpdate();
        if (this.chart) {
            this.chart.destroy();
        }
    }
}