$content = Get-Content style.css -Raw

$badBlock = @"
    body, .glass-card, .mobile-drawer, .site-footer {
        background-color: var(--bg) !important;
        color: var(--text) !important;
    }
    .hero-overlay {
        background: linear-gradient(to bottom, rgba(0,0,0,0.4), var(--bg)) !important;
    }
"@

$content = $content.Replace($badBlock, "")
Set-Content style.css -Value $content -Encoding UTF8
