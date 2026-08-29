$files = Get-ChildItem -Path . -Filter "*.html"

$newDrawer = @"
    <!-- Mobile Side Drawer -->
    <div class="mobile-drawer-overlay" id="mobileDrawerOverlay"></div>
    <div class="mobile-drawer" id="mobileDrawer">
        <div class="drawer-header">
            <span class="drawer-title">Menu</span>
            <button class="drawer-close" aria-label="Close menu">&times;</button>
        </div>
        <div class="drawer-content">
            <a href="index.html" class="drawer-link">Home</a>
            <a href="couple.html" class="drawer-link">The Couple</a>
            <div class="drawer-dropdown">
                <button class="drawer-dropdown-btn">Our Story <span class="arrow">&#9660;</span></button>
                <div class="drawer-dropdown-content">
                    <a href="roka.html">Roka</a>
                    <a href="engagement.html">Engagement</a>
                    <a href="sangeet.html">Sangeet</a>
                    <a href="haldi.html">Haldi</a>
                    <a href="wedding.html">Wedding</a>
                    <a href="reception.html">Reception</a>
                </div>
            </div>
            <div class="drawer-dropdown">
                <button class="drawer-dropdown-btn">Venue <span class="arrow">&#9660;</span></button>
                <div class="drawer-dropdown-content">
                    <a href="khajuraho-history.html">Khajuraho History</a>
                </div>
            </div>
            <a href="gallery.html" class="drawer-link">Gallery</a>
        </div>
    </div>
"@

foreach ($f in $files) {
    $content = Get-Content $f.FullName -Raw

    # Strip the old mobile-nav-overlay
    $content = $content -replace '(?s)<div class="mobile-nav-overlay" id="mobileNavOverlay">.*?</div>\s*</div>', ''
    
    # Inject the new drawer
    if ($content -notmatch "mobile-drawer-overlay") {
        $content = $content -replace "</nav>", "</nav>`n$newDrawer"
    }

    # Add color-scheme
    if ($content -notmatch "color-scheme") {
        $content = $content -replace "</head>", "  <meta name=`"color-scheme`" content=`"light only`" />`n</head>"
    }

    Set-Content $f.FullName -Value $content -Encoding UTF8
    Write-Host "Updated $($f.Name)"
}
