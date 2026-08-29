$root = Resolve-Path .
$backup = Resolve-Path '..\..\Vishal_Simoni-backup\Vishal_Simoni-main'

$backupFile = Join-Path $backup 'mobile-menu.js'
if (-Not (Test-Path $backupFile)) {
    Write-Error "Backup mobile-menu.js not found at $backupFile"
    exit 1
}

Copy-Item -Force $backupFile -Destination "$root\mobile-menu.js"
Write-Output 'Restored mobile-menu.js'

$insertion = @'
      <button class="hamburger-menu" aria-label="Toggle navigation menu">
        <span></span>
        <span></span>
        <span></span>
      </button>
    </nav>
    <div class="mobile-nav-overlay" id="mobileNavOverlay">
      <nav class="nav-links">
        <a href="index.html">Home</a>
        <a href="couple.html">The Couple</a>
        <div class="dropdown">
          <a href="event.html">Our Story</a>
          <div class="dropdown-content">
            <a href="roka.html">Roka</a>
            <a href="engagement.html">Engagement</a>
            <a href="sangeet.html">Sangeet</a>
            <a href="haldi.html">Haldi</a>
            <a href="wedding.html">Wedding</a>
            <a href="reception.html">Reception</a>
          </div>
        </div>
        <div class="dropdown">
          <a href="venue.html">Venue</a>
          <div class="dropdown-content">
            <a href="khajuraho-history.html">Khajuraho History</a>
          </div>
        </div>
        <a href="gallery.html">Gallery</a>
      </nav>
    </div>'@

Get-ChildItem -Filter '*.html' | ForEach-Object {
    $path = $_.FullName
    $content = Get-Content -Path $path -Raw -Encoding UTF8
    $changed = $false

    if ($content -notmatch 'id="mobileNavOverlay"') {
        if ($content -match '</div>\r?\n\s*</nav>') {
            $content = [Regex]::Replace($content, '</div>\r?\n\s*</nav>', '</div>' + $insertion, [Text.RegularExpressions.RegexOptions]::None)
            $changed = $true
        }
    }

    if ($content -notmatch 'mobile-menu\.js') {
        if ($content -match '<script src="countdown\.js"></script>') {
            $content = $content -replace '<script src="countdown\.js"></script>', '<script src="countdown.js"></script>\n  <script src="mobile-menu.js"></script>'
            $changed = $true
        }
    }

    if ($changed) {
        Set-Content -Path $path -Value $content -Encoding UTF8
        Write-Output "Updated $($_.Name)"
    }
}
