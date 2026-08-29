$files = Get-ChildItem -Path . -Filter "*.html"

foreach ($f in $files) {
    $content = Get-Content $f.FullName -Raw
    
    # Update og:image to absolute URL with correct .jpeg extension
    $content = $content -replace '<meta property="og:image" content="images/og-image.jpg" />', '<meta property="og:image" content="https://vishal15091997.github.io/Antigravity/images/og-image.jpeg" />'
    
    # Update og:url to the actual github pages URL
    $content = $content -replace '<meta property="og:url" content="https://vishalandsimoni.com/" />', '<meta property="og:url" content="https://vishal15091997.github.io/Antigravity/" />'

    Set-Content $f.FullName -Value $content -Encoding UTF8
    Write-Host "Fixed OG tags in $($f.Name)"
}
