$files = Get-ChildItem -Path . -Filter "*.html"

foreach ($f in $files) {
    $content = Get-Content $f.FullName -Raw

    if ($content -notmatch "supported-color-schemes") {
        $content = $content -replace '<meta name="color-scheme" content="light only" />', "<meta name=`"color-scheme`" content=`"light only`" />`n  <meta name=`"supported-color-schemes`" content=`"light only`" />"
        Set-Content $f.FullName -Value $content -Encoding UTF8
    }
}
