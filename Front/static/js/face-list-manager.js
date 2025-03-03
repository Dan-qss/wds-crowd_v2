// face-list-manager.js
export default class FaceListManager {
    constructor() {
        this.controller = null;
        this.initialize();
    }

    loadEmployees(data) {
        const facePanel = document.getElementById('face-panel');
        if (!facePanel) return;
        
        facePanel.innerHTML = '';

        data.forEach(employee => {
            const employeeContainer = document.createElement('div');
            employeeContainer.className = 'container face-data-container mb-2 py-2';

            // Format the timestamp
            const timestamp = new Date(employee.timestamp);
            const formattedDateTime = {
                date: timestamp.toLocaleDateString('en-US', {
                    year: 'numeric',
                    month: 'short',
                    day: 'numeric'
                }),
                time: timestamp.toLocaleTimeString('en-US', {
                    hour: 'numeric',
                    minute: '2-digit',
                    hour12: true
                })
            };

            // Format the name: replace underscore with space and capitalize first letters
            const formatName = (name) => {
                return name
                    .split('_')
                    .map(word => word.charAt(0).toUpperCase() + word.slice(1).toLowerCase())
                    .join(' ');
            };
            const imagePath = `../static/img/persons/${employee.person_name}.png`;
            const formattedName = formatName(employee.person_name);
            const formattedTime = `${formattedDateTime.time},${formattedDateTime.date}`;
            const formattedZone = formatName(employee.zone);


            employeeContainer.innerHTML = `
                <div class="row">
                    <div class="col-xl-3 col-lg-3 col-md-3 col-sm-3">
                       <img src="${imagePath}" alt="" class="face-img" id="person-img">
                    </div>
                    <div class="col-xl-7 col-lg-7 col-md-7 col-sm-7 pt-2">
                        <p class="personName" id="person-name">${formattedName}</p>
                        <p class="personPosi" id="person-posi">${employee.position}</p>
                        <p class="personPosi" id="person-posi">${formattedTime}</p>
                        <p class="personPosi" id="f-posi">${formattedZone}</p>
                        <p class="BWlist" id="BW-list">${employee.status } List</p>
                    </div>
                    <div class="col-xl-2 col-lg-2 col-md-2 col-sm-2">
                        <img src="../static/img/cms/${employee.status.includes('black') ? 'black' : 'white'}.png" alt="" class="mt-3" id="icon">
                    </div>
                </div>
            `;

            facePanel.appendChild(employeeContainer);
        });
    }

    async fetchData() {
        if (this.controller) {
            this.controller.abort();
        }
        this.controller = new AbortController();
        
        try {
            const response = await fetch('http://192.168.100.52:8020/recognitions/last/3', {
                signal: this.controller.signal
            });
            
            if (!response.ok) {
                throw new Error(`HTTP error! status: ${response.status}`);
            }
            
            const data = await response.json();
            this.loadEmployees(data);
        } catch (error) {
            if (error.name !== 'AbortError') {
                console.error('Error fetching data:', error);
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