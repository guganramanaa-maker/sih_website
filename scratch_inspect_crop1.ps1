Add-Type -AssemblyName System.Drawing
$bmp1 = [System.Drawing.Bitmap]::FromFile("crop_user_img1.png")
Write-Output "Image 1 crop size: $($bmp1.Width) x $($bmp1.Height)"
$darkTop = 0
for ($x = 50; $x -lt 550; $x += 10) {
    for ($y = 5; $y -lt 40; $y += 5) {
        $p = $bmp1.GetPixel($x, $y)
        if ($p.R -lt 100 -and $p.B -gt 100) { $darkTop++ }
    }
}
Write-Output "Dark pixels along very top (y: 5-40): $darkTop"

$orangeCount = 0
$logoX = 0; $logoY = 0
for ($x = 0; $x -lt 200; $x += 5) {
    for ($y = 0; $y -lt 150; $y += 5) {
        $p = $bmp1.GetPixel($x, $y)
        if ($p.R -gt 200 -and $p.G -gt 100 -and $p.B -lt 60) {
            $orangeCount++
            $logoX = $x; $logoY = $y
        }
    }
}
Write-Output "Orange pixels in logo area: $orangeCount, last sample: ($logoX, $logoY)"
$bmp1.Dispose()

