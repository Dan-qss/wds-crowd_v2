export default class VisitorListManager {
    constructor() {
        this.controller = null;
        this.initialize();
    }

    loadVisitors(data) {
        const visitorPanel = document.getElementById('visitor-panel');
        if (!visitorPanel) return;
        
        visitorPanel.innerHTML = '';

        data.forEach(visitor => {
            const visitorContainer = document.createElement('div');
            visitorContainer.className = 'unknown-data-container mx-1 my-1 py-1';

            // Format the timestamp with fallback
            const timestamp = visitor.timestamp ? new Date(visitor.timestamp) : new Date();
            const formattedDateTime = timestamp.toLocaleDateString('en-US', {
                year: 'numeric',
                month: 'numeric',
                day: 'numeric',
                hour: 'numeric',
                minute: '2-digit',
                hour12: true
            });

            // Format the name: replace underscore with space and capitalize first letters
            const formatName = (name) => {
                if (!name) return 'Unknown';
                return name
                    .split('_')
                    .map(word => word.charAt(0).toUpperCase() + word.slice(1).toLowerCase())
                    .join(' ');
            };

            // Format age range with fallback and age restriction
            const formatAgeRange = (age) => {
                if (!age || isNaN(age)) return 'Unknown age';
                if (age < 18) return ''; // Don't display age for minors
                return `${age - 2} - ${age + 3} years`;
            };

            // Use fallbacks for all properties
            const gender = visitor.gender;
            const age = visitor.age || 0;
            const zone = visitor.zone_name;

            const imagePath = `../static/img/persons/${gender.toLowerCase()}.png`;
            const formattedGender = formatName(gender);
            const formattedZone = formatName(zone);
            const ageDisplay = formatAgeRange(age);

            visitorContainer.innerHTML = `
                <div class="row">
                    <div class="col-3 d-flex justify-content-center align-items-start">
                        <img src="${imagePath}" class="unknown-img" alt="">
                    </div>
                    <div class="col-9">
                        <p class="unknown-info" id="unknown-name">${formattedGender}</p>
                        ${ageDisplay ? `<p class="unknown-info" id="unknown-age">${ageDisplay}</p>` : ''}
                        <p class="unknown-info" id="unknown-loca">${formattedZone}</p>
                        <p class="unknown-info" id="unknown-time">${formattedDateTime}</p>
                    </div>
                </div>
            `;

            visitorPanel.appendChild(visitorContainer);
        });
    }

    async fetchData() {
        if (this.controller) {
            this.controller.abort();
        }
        this.controller = new AbortController();
        
        try {
            const response = await fetch('http://192.168.100.219:8020/recognitions/unknown/last/10', {
                signal: this.controller.signal
            });
            
            if (!response.ok) {
                throw new Error(`HTTP error! status: ${response.status}`);
            }
            
            const data = await response.json();
            this.loadVisitors(data);
        } catch (error) {
            if (error.name !== 'AbortError') {
                console.error('Error fetching visitor data:', error);
            }
        }
    }

    initialize() {
        // Initial fetch
        this.fetchData();
        
        // Set up polling interval
        setInterval(() => this.fetchData(), 1000);
    }
}