// face-list-manager.js
export default class FaceListManager {
    constructor() {
        this.employees = [
            {
                "name": "Dania Hamdallah",
                "position": "Software Engineer",
                "status": "white List",
                "image_path": "../static/img/persons/Dania_Hamdallah.png"
            },
            {
                "name": "Abdullah Omaisan",
                "position": "Automation Section Head",
                "status": "Black List",
                "image_path": "../static/img/persons/Abdullah Omaisan.png"
            },
            // {
            //     "name": "Dr. Elie Metri",
            //     "position": "CEO",
            //     "status": "white List",
            //     "image_path": "../static/img/persons/Dr_Elie.png"
            // },
            {
                "name": "Sarah AlTujjar",
                "position": "AI & Software Engineering",
                "status": "Black List",
                "image_path": "../static/img/persons/Sarah_AlTujjar.png"
            },
            {
                "name": "Ammar Mohamed",
                "position": "R&D Section Head",
                "status": "Black List",
                "image_path": "../static/img/persons/Ammar Mohamed.png"
            },
            {
                "name": "Yousef Fathallah",
                "position": "VP of Operations",
                "status": "Black List",
                "image_path": "../static/img/persons/Yousef_Fathallah.png"
            },
            {
                "name": "Said Ankoud",
                "position": "Operations Manager",
                "status": "white List",
                "image_path": "../static/img/persons/Said Ankoud.png"
            },
            {
                "name": "Abdullah AbuSelmiya",
                "position": "Account Manager",
                "status": "white List",
                "image_path": "../static/img/persons/Abdullah_AbuSelmiya.png"
            },
            {
                "name": "Helmi Judeh",
                "position": "VP of Commercial",
                "status": "white List",
                "image_path": "../static/img/persons/Helmi Judeh.png"
            },
            {
                "name": "Marko Bjelotomic",
                "position": "VP of Technology",
                "status": "white List",
                "image_path": "../static/img/persons/Marko Bjelotomic.png"
            },
            {
                "name": "Fahad Alsumait",
                "position": "HR Manager",
                "status": "white List",
                "image_path": "../static/img/persons/Fahad Alsumait.png"
            },
            {
                "name": "Mohamed_Adil",
                "position": "AI Section Head",
                "status": "white List",
                "image_path": "../static/img/persons/Mohamed_Adil.png"
            },
            {
                "name": "Mustapha Batoot",
                "position": "Drones Section Head",
                "status": "white List",
                "image_path": "../static/img/persons/Mustapha Batoot.png"
            },
            {
                "name": "Abdulaziz Alsubaie",
                "position": "Digital Transformation Manager",
                "status": "white List",
                "image_path": "../static/img/persons/Abdulaziz Alsubaie.png"
            },
            
            {
                "name": "Mais Alkhatib",
                "position": "Software Engineer",
                "status": "Black List",
                "image_path": "../static/img/persons/Mais Alkhatib.png"
            },
            {
                "name": "Bilal Anwar",
                "position": "Software Engineer",
                "status": "white List",
                "image_path": "../static/img/persons/Bilal_Anwar.png"
            },
            {
                "name": "Deborah Binalla",
                "position": "Marketing Communications Manager",
                "status": "white List",
                "image_path": "../static/img/persons/Deborah Binalla.png"
            },
            {
                "name": "Ahmad Elmetwally",
                "position": "Finance Manager",
                "status": "white List",
                "image_path": "../static/img/persons/Ahmad Elmetwally.png"
            },
            {
                "name": "Manolito Sepe",
                "position": "Electronics Section Head",
                "status": "white List",
                "image_path": "../static/img/persons/Manolito Sepe.png"
            },
            {
                "name": "Mohamad Altala",
                "position": "Humanoids Section Head",
                "status": "white List",
                "image_path": "../static/img/persons/Mohamad Altala.png"
            }
        ];

        this.initialize();
    }

    shuffleArray(array) {
        for (let i = array.length - 1; i > 0; i--) {
            const j = Math.floor(Math.random() * (i + 1));
            [array[i], array[j]] = [array[j], array[i]];
        }
    }

    loadEmployees() {
        const facePanel = document.getElementById('face-panel');
        if (!facePanel) return;
        
        facePanel.innerHTML = '';

        this.employees.forEach(employee => {
            const employeeContainer = document.createElement('div');
            employeeContainer.className = 'container face-data-container mb-2 py-2';

            employeeContainer.innerHTML = `
                <div class="row">
                    <div class="col-xl-3 col-lg-3 col-md-3 col-sm-3">
                        <img src="${employee.image_path}" alt="" class="face-img" id="person-img">
                    </div>
                    <div class="col-xl-7 col-lg-7 col-md-7 col-sm-7 pt-2">
                        <p class="personName" id="person-name">${employee.name}</p>
                        <p class="personPosi" id="person-posi">${employee.position}</p>
                        <p class="BWlist" id="BW-list">${employee.status}</p>
                    </div>
                    <div class="col-xl-2 col-lg-2 col-md-2 col-sm-2">
                        <img src="../static/img/cms/${employee.status.includes('Black') ? 'black' : 'white'}.png" alt="" class="mt-3" id="icon">
                    </div>
                </div>
            `;

            facePanel.appendChild(employeeContainer);
        });
    }

    shuffleAndLoad() {
        this.shuffleArray(this.employees);
        this.loadEmployees();
    }

    initialize() {
        this.shuffleAndLoad();
        setInterval(() => this.shuffleAndLoad(), 8000);
    }
}

    