$files = Get-ChildItem -Path . -Filter "*.html"

foreach ($f in $files) {
    $content = Get-Content $f.FullName -Raw
    
    # Remove the orphaned "Venue" and "Gallery" div block that was left behind
    $content = $content -replace '(?s)\s*<div class="mobile-dropdown">\s*<button class="mobile-dropdown-btn">Venue.*?</div>\s*</div>\s*</header>', "`n  </header>"
    
    Set-Content $f.FullName -Value $content -Encoding UTF8
    Write-Host "Cleaned $($f.Name)"
}
