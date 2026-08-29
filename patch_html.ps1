$files = Get-ChildItem -Path . -Filter "*.html"

$ogTags = @"
  <meta property="og:title" content="Vishal & Simoni's Wedding" />
  <meta property="og:description" content="Join us in celebrating!" />
  <meta property="og:image" content="images/og-image.jpg" />
  <meta property="og:url" content="https://vishalandsimoni.com/" />
"@

$mobileNavStr = @"
      <button class="hamburger-menu" aria-label="Toggle navigation menu">
        <span></span>
        <span></span>
        <span></span>
      </button>
    </nav>
    <div class="mobile-nav-overlay" id="mobileNavOverlay">
      <div class="mobile-nav-content">
        <a href="index.html">Home</a>
        <a href="couple.html">The Couple</a>
        <div class="mobile-dropdown">
          <button class="mobile-dropdown-btn">Our Story ▼</button>
          <div class="mobile-dropdown-content">
            <a href="roka.html">Roka</a>
            <a href="engagement.html">Engagement</a>
            <a href="sangeet.html">Sangeet</a>
            <a href="haldi.html">Haldi</a>
            <a href="wedding.html">Wedding</a>
            <a href="reception.html">Reception</a>
          </div>
        </div>
        <div class="mobile-dropdown">
          <button class="mobile-dropdown-btn">Venue ▼</button>
          <div class="mobile-dropdown-content">
            <a href="khajuraho-history.html">Khajuraho History</a>
          </div>
        </div>
        <a href="gallery.html">Gallery</a>
      </div>
    </div>
"@

foreach ($f in $files) {
    $content = Get-Content $f.FullName -Raw
    
    if ($content -notmatch "og:title") {
        $content = $content -replace "</head>", "$ogTags`n</head>"
    }
    
    $content = $content -replace '<div class="countdown" aria-live="polite">', '<div class="countdown-sr-only" style="position:absolute; width:1px; height:1px; overflow:hidden; clip:rect(0,0,0,0);">Countdown to Wedding: November 20, 2026</div><div class="countdown" aria-hidden="true">'
    
    if ($content -notmatch "mobileNavOverlay") {
        $content = $content -replace '</div>\s*</nav>', "</div>`n$mobileNavStr"
    }

    if ($content -notmatch "mobile-menu.js") {
        $content = $content -replace '</body>', "  <script src=`"mobile-menu.js`"></script>`n</body>"
    }

    if ($f.Name -eq "index.html") {
        $loaderOld = @"
    window.addEventListener('load', () => {
      setTimeout(() => {
        const loader = document.getElementById('loader');
        if (loader) {
          loader.classList.add('hidden');
          document.body.classList.remove('loading-active');
        }
      }, 3500);
    });
"@
        $loaderNew = @"
    const hideLoader = () => {
      const loader = document.getElementById('loader');
      if (loader) {
        loader.classList.add('hidden');
        document.body.classList.remove('loading-active');
      }
    };
    window.addEventListener('load', () => {
      setTimeout(hideLoader, 200);
    });
    setTimeout(hideLoader, 3500);
"@
        $content = $content.Replace($loaderOld, $loaderNew)
    }

    Set-Content $f.FullName -Value $content -Encoding UTF8
    Write-Host "Patched $($f.Name)"
}
