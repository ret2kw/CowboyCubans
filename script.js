// Navigation scroll effect
const nav = document.getElementById('nav');
const navToggle = document.getElementById('nav-toggle');
const navMenu = document.getElementById('nav-menu');
const navOverlay = document.getElementById('nav-overlay');

// Track scroll direction and show/hide nav
let lastScrollY = window.scrollY;

// Create cowboy background grid
const startingRotations = []; // Store random starting angles

function createCowboyBackground() {
    const container = document.createElement('div');
    container.className = 'cowboy-bg';

    const grid = document.createElement('div');
    grid.className = 'cowboy-bg-grid';

    // Calculate how many tiles we need to cover the screen plus buffer
    const tileSize = 250;
    const cols = Math.ceil(window.innerWidth / tileSize) + 2;
    const rows = Math.ceil(window.innerHeight / tileSize) + 2;

    grid.style.setProperty('--cols', cols);
    grid.style.setProperty('--rows', rows);

    // Create grid of horse tiles
    for (let i = 0; i < rows * cols; i++) {
        const tile = document.createElement('div');
        tile.className = 'cowboy-tile';
        const img = document.createElement('img');
        img.src = 'images/Connors_cubanos__28US_Letter_29__282_29.png';
        img.alt = '';
        img.setAttribute('aria-hidden', 'true');
        tile.appendChild(img);
        grid.appendChild(tile);

        // Assign random starting rotation (-45 to 45 degrees)
        startingRotations.push((Math.random() * 90) - 45);
    }

    container.appendChild(grid);
    document.body.insertBefore(container, document.body.firstChild);

    return grid.querySelectorAll('.cowboy-tile');
}

const cowboyTiles = createCowboyBackground();

// Animate horses with back-and-forth bucking motion on scroll
const maxRotation = 20; // Maximum rotation in degrees
const frequency = 0.008; // How fast the oscillation cycles

function updateCowboyRotation() {
    const scrollY = window.scrollY;

    cowboyTiles.forEach((tile, index) => {
        // Offset each tile's phase slightly for a wave effect
        const phaseOffset = index * 0.5;
        // Use sine wave for back-and-forth motion, add random starting rotation
        const scrollRotation = Math.sin((scrollY * frequency) + phaseOffset) * maxRotation;
        const totalRotation = startingRotations[index] + scrollRotation;
        tile.style.transform = `rotate(${totalRotation}deg)`;
    });
}

window.addEventListener('scroll', () => {
    const currentScrollY = window.scrollY;

    // Add scrolled background
    if (currentScrollY > 50) {
        nav.classList.add('scrolled');
    } else {
        nav.classList.remove('scrolled');
    }

    // Hide nav on scroll down, show on scroll up
    if (currentScrollY > lastScrollY && currentScrollY > 100) {
        nav.classList.add('hidden');
        navMenu.classList.add('hidden');
    } else {
        nav.classList.remove('hidden');
        navMenu.classList.remove('hidden');
    }

    // Update cowboy rotation
    updateCowboyRotation();

    lastScrollY = currentScrollY;
});

// Initial rotation state
updateCowboyRotation();

// Mobile menu toggle
function closeMenu() {
    navToggle.classList.remove('active');
    navMenu.classList.remove('active');
    navOverlay.classList.remove('active');
    nav.classList.remove('menu-open');
}

navToggle.addEventListener('click', () => {
    navToggle.classList.toggle('active');
    navMenu.classList.toggle('active');
    navOverlay.classList.toggle('active');
    nav.classList.toggle('menu-open');
});

// Close mobile menu when clicking overlay (the dark background)
if (navOverlay) {
    navOverlay.addEventListener('click', closeMenu);
}

// Close mobile menu after clicking nav links (delay lets browser handle navigation first)
navMenu.querySelectorAll('a').forEach(link => {
    link.addEventListener('click', () => {
        setTimeout(closeMenu, 100);
    });
});
