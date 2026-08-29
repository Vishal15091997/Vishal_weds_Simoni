$folders = @("images/engagement", "images/haldi", "images/reception", "images/roka", "images/sangeet", "images/wedding")

foreach ($folder in $folders) {
    if (-Not (Test-Path $folder)) { continue }
    $manifestPath = "$folder\manifest.json"
    $images = Get-ChildItem -Path $folder -File | Where-Object { $_.Extension -match "\.(jpg|jpeg|png)$" } | Sort-Object Name | Select-Object -ExpandProperty Name
    if ($null -eq $images) { $images = @() }
    if ($images.GetType().IsArray -eq $false -and $images.Length -gt 0) { $images = @($images) }
    $json = $images | ConvertTo-Json -Compress
    Set-Content -Path $manifestPath -Value $json -Encoding UTF8
    Write-Host "Generated manifest for $folder with $($images.Count) images."
}
