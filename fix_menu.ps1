$files = Get-ChildItem -Path . -Filter "*.html"

foreach ($f in $files) {
    $content = Get-Content $f.FullName -Raw

    if ($content -notmatch "Overview \(Our Story\)") {
        $content = $content -replace '(<button class="drawer-dropdown-btn">Our Story <span class="arrow">&#9660;</span></button>\s*<div class="drawer-dropdown-content">)', "`$1`n                    <a href=`"event.html`">Overview (Our Story)</a>"
        
        $content = $content -replace '(<button class="drawer-dropdown-btn">Venue <span class="arrow">&#9660;</span></button>\s*<div class="drawer-dropdown-content">)', "`$1`n                    <a href=`"venue.html`">Venue Overview</a>"
        
        Set-Content $f.FullName -Value $content -Encoding UTF8
    }
}
