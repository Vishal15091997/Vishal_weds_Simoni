Add-Type -AssemblyName System.Drawing
$folders = @(".", "images", "Gallery", "images/engagement", "images/haldi", "images/reception", "images/roka", "images/sangeet", "images/wedding")

$jpegCodec = [System.Drawing.Imaging.ImageCodecInfo]::GetImageEncoders() | Where-Object { $_.MimeType -eq 'image/jpeg' }
$encoderParams = New-Object System.Drawing.Imaging.EncoderParameters(1)
$encoderParams.Param[0] = New-Object System.Drawing.Imaging.EncoderParameter([System.Drawing.Imaging.Encoder]::Quality, [long]80)

foreach ($folder in $folders) {
    if (-Not (Test-Path $folder)) { continue }
    $files = Get-ChildItem -Path $folder -File | Where-Object { $_.Extension -match "\.(jpg|jpeg|png)$" }
    foreach ($file in $files) {
        if ($file.Length -lt 400000) { continue } # skip if already < 400KB

        Write-Host "Compressing $($file.FullName) ($($file.Length) bytes)..."
        try {
            $img = [System.Drawing.Image]::FromFile($file.FullName)
            
            # Handle orientation for JPEGs
            if ($img.PropertyIdList -contains 274) {
                $orientationItem = $img.GetPropertyItem(274)
                $orientation = [BitConverter]::ToUInt16($orientationItem.Value, 0)
                switch ($orientation) {
                    2 { $img.RotateFlip([System.Drawing.RotateFlipType]::RotateNoneFlipX) }
                    3 { $img.RotateFlip([System.Drawing.RotateFlipType]::Rotate180FlipNone) }
                    4 { $img.RotateFlip([System.Drawing.RotateFlipType]::Rotate180FlipX) }
                    5 { $img.RotateFlip([System.Drawing.RotateFlipType]::Rotate90FlipX) }
                    6 { $img.RotateFlip([System.Drawing.RotateFlipType]::Rotate90FlipNone) }
                    7 { $img.RotateFlip([System.Drawing.RotateFlipType]::Rotate270FlipX) }
                    8 { $img.RotateFlip([System.Drawing.RotateFlipType]::Rotate270FlipNone) }
                }
            }

            $newWidth = $img.Width
            $newHeight = $img.Height
            if ($newWidth -gt 1920) {
                $ratio = 1920.0 / $newWidth
                $newWidth = 1920
                $newHeight = [math]::Round($img.Height * $ratio)
            }
            
            $newImg = New-Object System.Drawing.Bitmap($newWidth, $newHeight)
            $graphics = [System.Drawing.Graphics]::FromImage($newImg)
            $graphics.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
            $graphics.DrawImage($img, 0, 0, $newWidth, $newHeight)
            
            $img.Dispose()
            
            $tempFile = $file.FullName + ".tmp"
            $newImg.Save($tempFile, $jpegCodec, $encoderParams)
            $newImg.Dispose()
            $graphics.Dispose()
            
            Remove-Item $file.FullName -Force
            Move-Item -Path $tempFile -Destination $file.FullName -Force
            Write-Host "Compressed $($file.Name)"
        } catch {
            Write-Host "Error processing $($file.Name): $($_.Exception.Message)"
        }
    }
}
