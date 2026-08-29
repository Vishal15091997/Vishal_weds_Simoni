$galleryPath = "Gallery"
$manifestPath = "Gallery\manifest.json"
if (-Not (Test-Path $galleryPath)) {
    Write-Host "Gallery directory not found."
    exit
}
$images = Get-ChildItem -Path $galleryPath -File | Where-Object { $_.Extension -match "\.(jpg|jpeg|png)$" } | Sort-Object Name | Select-Object -ExpandProperty Name
if ($null -eq $images) {
    $images = @()
}
if ($images.GetType().IsArray -eq $false -and $images.Length -gt 0) {
    $images = @($images)
}
$json = $images | ConvertTo-Json -Compress
Set-Content -Path $manifestPath -Value $json -Encoding UTF8
Write-Host "Generated manifest with $($images.Count) images."
