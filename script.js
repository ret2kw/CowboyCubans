// Navigation scroll effect
const nav = document.getElementById('nav');
const navToggle = document.getElementById('nav-toggle');
const navMenu = document.getElementById('nav-menu');

// Track scroll direction and show/hide nav
let lastScrollY = window.scrollY;

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
    } else {
        nav.classList.remove('hidden');
    }

    lastScrollY = currentScrollY;
});

// Mobile menu toggle
navToggle.addEventListener('click', () => {
    navToggle.classList.toggle('active');
    navMenu.classList.toggle('active');
    nav.classList.toggle('menu-open');
});

// Close mobile menu when clicking a link
navMenu.querySelectorAll('a').forEach(link => {
    link.addEventListener('click', () => {
        navToggle.classList.remove('active');
        navMenu.classList.remove('active');
        nav.classList.remove('menu-open');
    });
});

// Smooth scroll for anchor links (fallback for browsers without CSS smooth scroll)
document.querySelectorAll('a[href^="#"]').forEach(anchor => {
    anchor.addEventListener('click', function(e) {
        e.preventDefault();
        const target = document.querySelector(this.getAttribute('href'));
        if (target) {
            const navHeight = nav.offsetHeight;
            const extraOffset = 70; // scroll past section padding
            const targetPosition = target.getBoundingClientRect().top + window.pageYOffset - navHeight + extraOffset;

            window.scrollTo({
                top: targetPosition,
                behavior: 'smooth'
            });
        }
    });
});
