$files = Get-ChildItem -Path . -Filter "*.html"

foreach ($f in $files) {
    $content = Get-Content $f.FullName -Raw

    $content = $content -replace 'https://vishal15091997.github.io/Antigravity', 'https://vishal15091997.github.io/Vishal_weds_Simoni'

    Set-Content $f.FullName -Value $content -Encoding UTF8
    Write-Host "Updated OG URL in $($f.Name)"
}
