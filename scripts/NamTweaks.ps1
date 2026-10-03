param([ValidateSet('Performance','Balanced','Restore')][string]$Preset='Balanced')
$ErrorActionPreference='Stop'
$backup=Join-Path $env:USERPROFILE 'NamTweaks-Backup'
New-Item -ItemType Directory -Force -Path $backup | Out-Null
$gameUser=Join-Path $env:LOCALAPPDATA 'FortniteGame\Saved\Config\WindowsClient'

function Backup-Config {
  if(Test-Path $gameUser){ Copy-Item $gameUser (Join-Path $backup 'WindowsClient') -Recurse -Force }
}
function Restore-Config {
  $src=Join-Path $backup 'WindowsClient'
  if(Test-Path $src){ New-Item -ItemType Directory -Force -Path $gameUser | Out-Null; Copy-Item $src\* $gameUser -Recurse -Force; Write-Host 'Fortnite config restored.' }
  else { Write-Host 'No NamTweaks backup found.' }
}

if($Preset -eq 'Restore'){ Restore-Config; exit }
Backup-Config
if(Test-Path $gameUser){
  $engine=Join-Path $gameUser 'GameUserSettings.ini'
  if(Test-Path $engine){
    $content=Get-Content $engine -Raw
    $content=$content -replace '(?m)^bUseVSync=.*$','bUseVSync=False'
    if($Preset -eq 'Performance'){ $content=$content -replace '(?m)^FrameRateLimit=.*$','FrameRateLimit=0.000000' }
    Set-Content $engine $content -Encoding UTF8
  }
}
Write-Host "NamTweaks $Preset preset applied. Backup: $backup"
