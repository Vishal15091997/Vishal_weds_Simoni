$files = Get-ChildItem -Path . -Filter "*.html"

foreach ($f in $files) {
    $content = Get-Content $f.FullName -Raw

    if ($content -notmatch "mobile_nav.css") {
        $content = $content -replace '<link rel="stylesheet" href="style.css" />', "<link rel=`"stylesheet`" href=`"style.css`" />`n  <link rel=`"stylesheet`" href=`"mobile_nav.css`" />"
        Set-Content $f.FullName -Value $content -Encoding UTF8
        Write-Host "Linked CSS in $($f.Name)"
    }
}
