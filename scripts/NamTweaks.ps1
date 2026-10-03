param(
  [ValidateSet('Balanced','Performance','Restore')]
  [string]$Preset='Balanced'
)
$ErrorActionPreference='Stop'
$backup=Join-Path $env:USERPROFILE 'NamTweaks-Backup'
$gameUser=Join-Path $env:LOCALAPPDATA 'FortniteGame\Saved\Config\WindowsClient'
New-Item -ItemType Directory -Force -Path $backup | Out-Null

function Backup-Config {
  if(Test-Path $gameUser){
    $dest=Join-Path $backup 'WindowsClient'
    if(Test-Path $dest){ Remove-Item $dest -Recurse -Force }
    Copy-Item $gameUser $dest -Recurse -Force
    Write-Host "Backup created: $dest"
  } else { Write-Warning "Fortnite config folder was not found. Start Fortnite once, then run NamTweaks again." }
}
function Restore-Config {
  $src=Join-Path $backup 'WindowsClient'
  if(!(Test-Path $src)){ Write-Warning "No NamTweaks backup found at $src"; return }
  New-Item -ItemType Directory -Force -Path $gameUser | Out-Null
  Copy-Item (Join-Path $src '*') $gameUser -Recurse -Force
  Write-Host 'Fortnite config restored.'
}
function Set-IniValue([string]$Path,[string]$Key,[string]$Value){
  $lines=@()
  if(Test-Path $Path){ $lines=Get-Content $Path }
  $found=$false
  $lines=@($lines | ForEach-Object {
    if($_ -match ('^'+[regex]::Escape($Key)+'=')){ $found=$true; "$Key=$Value" } else { $_ }
  })
  if(!$found){ $lines += "$Key=$Value" }
  Set-Content -Path $Path -Value $lines -Encoding UTF8
}

if($Preset -eq 'Restore'){ Restore-Config; exit }
Backup-Config
if(!(Test-Path $gameUser)){ exit 1 }
$settings=Join-Path $gameUser 'GameUserSettings.ini'
if(!(Test-Path $settings)){ New-Item -ItemType File -Path $settings -Force | Out-Null }
Set-IniValue $settings 'bUseVSync' 'False'
if($Preset -eq 'Performance'){ Set-IniValue $settings 'FrameRateLimit' '0.000000' }
Write-Host "NamTweaks $Preset applied successfully."
Write-Host 'Run Start-NamTweaks.bat again anytime to reapply, or use: powershell -File scripts\NamTweaks.ps1 -Preset Restore'
