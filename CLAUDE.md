# Cowboy Cubans

Static marketing website for Cowboy Cubans - an Austin-based Cuban sandwich food truck with Western-Cuban fusion branding.

## Tech Stack

- Vanilla HTML5/CSS3/JavaScript (no frameworks or build tools)
- Google Fonts: DM Sans, IM Fell English SC, Rye
- Docker + Python HTTP server for deployment
- Traefik reverse proxy on Tailscale network

## Directory Structure

```
├── index.html      # Main webpage
├── styles.css      # All styles with CSS variables
├── script.js       # Nav scroll, mobile menu, smooth scrolling
├── serve.sh        # Docker deployment script
└── images/         # PNG assets (logos, menu, story images)
```

## Development

No build step required. Open `index.html` directly or use any static server:

```bash
python -m http.server 8000
```

## Deployment

```bash
./serve.sh
```

Deploys to: `https://tailscale-coder.curl-mahi.ts.net/cowboycuban/`

Stop container: `sudo docker rm -f cowboycuban-http`

## Key Patterns

### CSS Variables

```css
--color-bg: #A8D8E8       /* light blue */
--color-bg-dark: #8ec5d6  /* darker blue */
--color-text: #1a1a1a     /* dark text */
--color-gold: #8B6914     /* accent headers */
--nav-height: 70px
--container-max-width: 900px
```

### Font Classes

- `.font-western` - 'Rye' (Western/cowboy style)
- `.font-gothic` - 'IM Fell English SC' (elegant)
- `.font-body` - 'DM Sans' (body text)

### Responsive Breakpoints

- 768px - tablet
- 480px - mobile

## Page Sections

1. **Hero** - Brand intro with scroll indicator
2. **Menu** - Sandwich items with pricing
3. **Story** - Founder narrative
4. **Find Us** - Location and hours
5. **Footer** - Contact info

## Business Info

- Location: 620 W 29th St, Austin, TX 78705
- Hours: Mon-Fri 4PM-9PM (Closed Sat-Sun)
