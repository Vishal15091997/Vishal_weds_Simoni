$css = @"

/* AGGRESSIVELY FORCE LIGHT MODE */
:root {
    color-scheme: light !important;
    supported-color-schemes: light !important;
}

@media (prefers-color-scheme: dark) {
    :root {
        --maroon: #730F15 !important;
        --gold: #D4AF37 !important;
        --light-gold: #F4E8C1 !important;
        --bg: #FDFBF7 !important;
        --text: #2C1810 !important;
        --accent: #E5C058 !important;
    }
    body, .glass-card, .mobile-drawer, .site-footer {
        background-color: var(--bg) !important;
        color: var(--text) !important;
    }
    .hero-overlay {
        background: linear-gradient(to bottom, rgba(0,0,0,0.4), var(--bg)) !important;
    }
}
"@

Add-Content style.css $css
