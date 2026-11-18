param([string]$OutputPath = (Join-Path $PSScriptRoot 'entry.png'))
$ErrorActionPreference = 'Stop'
Add-Type -AssemblyName System.Drawing

# Original geometric editorial artwork. No downloaded photographs or graphics.
# Windows GDI+ is a build-time tool only. The entry runtime copies the PNG.
$paper = '#F4EFE5'
$ink = '#152F3B'
$muted = '#51626A'
$red = '#B74832'
$teal = '#236F75'
$light = '#D5E2DD'
$rule = '#C6C9BE'
$bitmap = New-Object System.Drawing.Bitmap 1024,1024
$g = [System.Drawing.Graphics]::FromImage($bitmap)
$g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
$g.TextRenderingHint = [System.Drawing.Text.TextRenderingHint]::AntiAliasGridFit
$g.Clear([System.Drawing.ColorTranslator]::FromHtml($paper))
$script:owned = [System.Collections.Generic.List[System.IDisposable]]::new()

function Brush([string]$color) {
    $b = [System.Drawing.SolidBrush]::new([System.Drawing.ColorTranslator]::FromHtml($color))
    $script:owned.Add($b)
    return $b
}
function Pen([string]$color, [single]$width = 1) {
    $p = [System.Drawing.Pen]::new([System.Drawing.ColorTranslator]::FromHtml($color), $width)
    $script:owned.Add($p)
    return $p
}
function Rect($x,$y,$w,$h,$color) { $g.FillRectangle((Brush $color),[single]$x,[single]$y,[single]$w,[single]$h) }
function Line($x1,$y1,$x2,$y2,$color,$width=1) { $g.DrawLine((Pen $color $width),[single]$x1,[single]$y1,[single]$x2,[single]$y2) }
function Ellipse($x,$y,$w,$h,$color) { $g.FillEllipse((Brush $color),[single]$x,[single]$y,[single]$w,[single]$h) }
function Poly($coordinates,$color) {
    $points = [System.Drawing.PointF[]]@(for($i=0; $i -lt $coordinates.Count; $i+=2) {
        [System.Drawing.PointF]::new($coordinates[$i],$coordinates[$i+1])
    })
    $g.FillPolygon((Brush $color),$points)
}
function Text($text,$x,$y,$size,$color=$ink,$family='Arial',$bold=$false) {
    $style = if($bold){[System.Drawing.FontStyle]::Bold}else{[System.Drawing.FontStyle]::Regular}
    $font = [System.Drawing.Font]::new($family,[single]$size,$style,[System.Drawing.GraphicsUnit]::Pixel)
    $format = [System.Drawing.StringFormat]::GenericTypographic.Clone()
    $format.FormatFlags = $format.FormatFlags -bor [System.Drawing.StringFormatFlags]::NoWrap
    $g.DrawString($text,$font,(Brush $color),[System.Drawing.PointF]::new($x,$y),$format)
    $font.Dispose()
    $format.Dispose()
}
function Waves($x,$y,$width,$color,$count=3) {
    for($row=0;$row -lt $count;$row++) {
        for($i=0;$i -lt $width;$i+=32) {
            $g.DrawArc((Pen $color 2),[single]($x+$i),[single]($y+$row*14),32,12,0,180)
        }
    }
}

# Masthead: the date remains prominent at a 300-pixel display width.
Rect 40 34 8 66 $red
Text 'THE WORLD' 65 29 60 $ink 'Georgia' $true
Text 'IN ONE DAY' 733 44 32 $ink 'Arial' $true
Line 40 111 984 111 $ink 3
Text '17 NOVEMBER 2026' 40 126 52 $ink 'Arial' $true
Text 'TUESDAY' 793 147 26 $red 'Arial' $true
Line 40 197 984 197 $ink 2

# Lead: an explicitly schematic bridge scene, not a simulated photograph.
Text '01 / EUROPE' 40 217 22 $red 'Arial' $true
Text 'Ukraine strikes' 40 253 58 $ink 'Georgia' $true
Text 'Kerch Bridge' 40 319 58 $ink 'Georgia' $true
Text 'Drones and missiles hit the' 42 397 29 $ink
Text 'Russia-Crimea road and rail link.' 42 433 29 $ink
Text 'AP / 17 NOV' 42 493 19 $muted 'Arial' $true

Rect 588 218 396 306 $light
Text 'KERCH STRAIT' 607 233 19 $teal 'Arial' $true
# Abstract coastlines convey the crossing, with sovereignty stated in text.
Poly @(588,297,625,285,653,302,680,310,692,330,688,355,654,366,637,384,588,388) '#A7B6A0'
Poly @(984,269,958,282,940,305,914,323,922,346,950,361,984,357) '#A7B6A0'
Text 'CRIMEA' 604 276 22 $ink 'Arial' $true
Text 'RUSSIA' 879 274 22 $ink 'Arial' $true
# Intact rear rail line and interrupted foreground road are symbolic.
Line 610 359 966 359 $muted 5
for($x=625;$x -lt 970;$x+=47) { Rect $x 359 7 40 $muted }
$g.DrawArc((Pen $muted 5),716,309,127,102,180,180)
Rect 608 388 132 12 $ink
Rect 833 388 138 12 $ink
for($x=624;$x -lt 733;$x+=47) { Rect $x 398 8 42 $ink }
for($x=850;$x -lt 971;$x+=47) { Rect $x 398 8 42 $ink }
Poly @(751,408,784,415,801,435,766,432) $red
Line 755 374 773 362 $red 4
Line 796 364 812 376 $red 4
Waves 607 446 354 $teal 2
Text 'Occupied Ukrainian peninsula' 606 486 18 $ink
Text 'SCHEMATIC' 876 510 12 $muted 'Arial' $true
Line 40 546 984 546 $ink 3

# Four briefs. Headline size is 40 pixels, approximately 12 at 300 wide.
Line 512 568 512 942 $rule 1
Line 40 755 984 755 $rule 1

# Trade icon: two containers and two opposing arrows.
Text '02 / CANADA + CHINA' 40 568 21 $teal 'Arial' $true
Text 'Tariff relief' 40 600 43 $ink 'Georgia' $true
Text 'expands' 40 648 43 $ink 'Georgia' $true
Text 'Carney and Xi agree new cuts.' 42 711 25 $ink
Rect 390 606 82 29 $teal
Rect 390 656 82 29 $red
for($x=403;$x -lt 468;$x+=15) { Line $x 611 $x 629 $paper 1; Line $x 661 $x 679 $paper 1 }
Line 387 644 474 644 $ink 2
Poly @(474,644,464,638,464,650) $ink

# Gaza: shelter, rain, and rising water, with the UN warning dated today.
Text '03 / GAZA' 544 568 21 $red 'Arial' $true
Text 'Winter floods' 544 600 43 $ink 'Georgia' $true
Text 'hit shelters' 544 648 43 $ink 'Georgia' $true
Text 'UN warns of access and aid gaps.' 546 711 25 $ink
Poly @(877,684,918,632,961,684) $teal
Poly @(910,684,919,651,930,684) $paper
for($x=882;$x -lt 962;$x+=19) { Line $x 605 ($x-8) 623 $muted 2 }
Waves 870 685 88 $teal 2

# Sudan: geographic outline is original and simplified, not a boundary map.
Text '04 / SUDAN' 40 778 21 $red 'Arial' $true
Text 'UN: drones drive' 40 810 40 $ink 'Georgia' $true
Text 'civilian deaths' 40 858 43 $ink 'Georgia' $true
Text 'New report warns of civilian harm.' 42 919 24 $ink
Poly @(417,814,472,814,471,840,484,854,464,873,459,898,435,909,419,890,407,862) $light
Ellipse 432 850 18 18 $red
Line 441 842 441 828 $red 3
Line 441 876 441 889 $red 3
Line 423 859 411 859 $red 3
Line 460 859 473 859 $red 3

# Climate: a blue planet and wave stripes; no claim of a completed treaty.
Text '05 / COP31 / TURKIYE' 544 778 21 $teal 'Arial' $true
Text 'Ocean protection' 544 810 36 $ink 'Georgia' $true
Text 'on the table' 544 858 43 $ink 'Georgia' $true
Text 'Funding gaps persist at talks.' 546 919 25 $ink
Ellipse 893 825 76 76 $teal
$g.DrawEllipse((Pen $paper 2),908,825,43,76)
Line 896 850 965 850 $paper 2
Line 896 873 965 873 $paper 2

Line 40 965 984 965 $ink 2
Text 'FIVE STORIES / ONE DAY' 40 982 18 $ink 'Arial' $true
Text 'SOURCES: AP / UN / CANADA PMO' 600 982 18 $muted 'Arial' $true

$g.Dispose()
$bitmap.Save([System.IO.Path]::GetFullPath($OutputPath),[System.Drawing.Imaging.ImageFormat]::Png)
$bitmap.Dispose()
foreach($item in $script:owned) { $item.Dispose() }
Write-Output "Rendered original artwork: $OutputPath"
