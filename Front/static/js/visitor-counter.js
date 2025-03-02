export default class VisitorCounter {
    constructor() {
        this.updateInterval = null;
        this.previousValues = {
            total: 0,
            cameras: {8: 0, 9: 0, 10: 0, 11: 0, 12: 0}
        };
        this.startAutoUpdate();
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

    animateValue(element, start, end, duration = 500) {
        if (!element) return;
        
        const range = end - start;
        const increment = range / (duration / 16); // 60fps
        let current = start;
        
        const animate = () => {
            current += increment;
            
            if ((increment >= 0 && current >= end) || (increment < 0 && current <= end)) {
                element.textContent = Math.round(end);
                // Add pulse animation class
                element.classList.add('pulse-animation');
                // Remove the class after animation completes
                setTimeout(() => element.classList.remove('pulse-animation'), 300);
                return;
            }
            
            element.textContent = Math.round(current);
            requestAnimationFrame(animate);
        };
        
        animate();
    }

    async updateLatestData() {
        const endTime = new Date();
        const startTime = new Date(endTime - (60 * 1000));

        try {
            const url = `http://192.168.100.65:8010/analysis/zone-occupancy?start_time=${encodeURIComponent(this.formatDateTime(startTime))}&end_time=${encodeURIComponent(this.formatDateTime(endTime))}`;
            const response = await fetch(url);

            if (!response.ok) {
                console.error('API Response Error:', response.status, response.statusText);
                throw new Error(`HTTP error! status: ${response.status}`);
            }

            const data = await response.json();

            if (data.camera_data) {
                const counters = {
                    individual: {},
                    total: 0
                };

                data.camera_data.forEach(camera => {
                    const peopleCount = parseFloat(camera.average_people);
                    if (isNaN(peopleCount)) {
                        console.warn(`Invalid people count for camera ${camera.camera_id}:`, camera.average_people);
                        return;
                    }

                    const roundedPeople = Math.round(peopleCount);
                    counters.individual[camera.camera_id] = roundedPeople;
                    counters.total += roundedPeople;

                    const elementIds = {
                        8: 'drons-num',
                        9: 'barns-num',
                        10: 'humanoid-num',
                        11: 'amr-num',
                        12: 'catwalk-num'
                    };

                    const elementId = elementIds[camera.camera_id];
                    if (elementId) {
                        const element = document.getElementById(elementId);
                        if (element) {
                            // Animate from previous value to new value
                            this.animateValue(
                                element,
                                this.previousValues.cameras[camera.camera_id],
                                roundedPeople
                            );
                            this.previousValues.cameras[camera.camera_id] = roundedPeople;
                        }
                    }
                });

                const totalElement = document.getElementById('total-num');
                if (totalElement) {
                    // Animate total from previous value to new value
                    this.animateValue(
                        totalElement,
                        this.previousValues.total,
                        counters.total
                    );
                    this.previousValues.total = counters.total;
                }
            }
        } catch (error) {
            console.error('Error updating latest data:', error);
        }
    }

    startAutoUpdate() {
        this.updateLatestData();
        this.updateInterval = setInterval(() => {
            this.updateLatestData();
        }, 1000);
    }

    stopAutoUpdate() {
        if (this.updateInterval) {
            clearInterval(this.updateInterval);
            this.updateInterval = null;
            console.log('Auto-update stopped');
        }
    }

    destroy() {
        this.stopAutoUpdate();
    }
}