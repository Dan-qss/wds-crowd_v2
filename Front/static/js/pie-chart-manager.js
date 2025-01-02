export default class PieChartManager {
    constructor() {
        this.chart = null;
        this.initializeChart();
        
        // Initial test data
        this.updateData({
            blacklist: 55,
            whitelist: 45
        });
    }

    initializeChart() {
        // Make sure the element exists
        const canvas = document.getElementById('pieChart');
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
                            padding: 15,
                            font: {
                                size: 10,
                                family: "'Segoe UI', sans-serif",
                                // weight: 'bold'  
                            },
                            color: '#fff',  // Legend text color
                            generateLabels: function(chart) {
                                const data = chart.data;
                                return data.labels.map((label, i) => ({
                                    text: `${label} ${data.datasets[0].data[i]}%`,
                                    fillStyle: data.datasets[0].backgroundColor[i],
                                    hidden: false,
                                    index: i,
                                    fontColor: '#fff'  // Add this line
                                }));
                            }
                        }
                    },
                    tooltip: {
                        enabled: true,
                        backgroundColor: 'rgba(0, 0, 0, 0.8)',
                        titleFont: {
                            size: 11,
                            color: '#fff'  // Add this
                        },
                        bodyFont: {
                            size: 11,
                            color: '#fff'  // Add this
                        },
                        padding: 10,
                        callbacks: {
                            label: function(context) {
                                return `${context.label}: ${context.parsed}%`;
                            }
                        },
                        titleColor: '#fff',  // Add this
                        bodyColor: '#fff'    // Add this
                    }
                }
            }
        });
        
        
    }

    updateData(data) {
        if (this.chart) {
            this.chart.data.datasets[0].data = [
                data.blacklist,
                data.whitelist
            ];
            this.chart.update(); // Update without animation
        }
    }

    // handleWebSocketData(data) {
    //     if (data && data.blacklistPercentage !== undefined && data.whitelistPercentage !== undefined) {
    //         this.updateData({
    //             blacklist: data.blacklistPercentage,
    //             whitelist: data.whitelistPercentage
    //         });
    //     }
    // }
}