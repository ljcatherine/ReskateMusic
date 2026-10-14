param([Parameter(Mandatory=$true)][string]$ReSkateFolder)
$ErrorActionPreference = 'Stop'
$targetFolder = (Resolve-Path -LiteralPath $ReSkateFolder).Path
$targetDll = Join-Path $targetFolder 'ReSkate.dll'
if (-not (Test-Path -LiteralPath $targetDll -PathType Leaf)) { throw 'Choose the existing ReSkate runtime folder containing ReSkate.dll.' }
if (Get-Process -Name Skate -ErrorAction SilentlyContinue) { throw 'Close Skate before installing.' }
$gameExe = Join-Path $targetFolder 'Skate.exe'
if (-not (Test-Path -LiteralPath $gameExe)) { throw 'Skate.exe is missing from the runtime folder.' }
$expectedGame = 'FBCE74D5E28EF525DBBA2CB4ADBEBC13405BDBD88F31BC940BCA45E4AE88B8F9'
if ((Get-FileHash -LiteralPath $gameExe -Algorithm SHA256).Hash -ne $expectedGame) { throw 'Unsupported Skate build. This mod targets Steam build 25414733.' }
$backup = "$targetDll.backup-$(Get-Date -Format yyyyMMdd-HHmmss)"
Copy-Item -LiteralPath $targetDll -Destination $backup
Copy-Item -LiteralPath (Join-Path $PSScriptRoot 'ReSkate.dll') -Destination $targetDll -Force
Write-Host "Installed ReskateMusic. Original saved as $backup"
Write-Host 'Open pause menu > Mod Options > Music. A launcher update may replace this custom DLL.'

$settingsFile = Join-Path $targetFolder 'ReSkateLauncher.settings.json'
if (Test-Path -LiteralPath $settingsFile) {
    $settings = Get-Content -LiteralPath $settingsFile -Raw | ConvertFrom-Json
    Copy-Item -LiteralPath $settingsFile -Destination "$settingsFile.backup-$(Get-Date -Format yyyyMMdd-HHmmss)"
    $settings | Add-Member -NotePropertyName updates -NotePropertyValue $false -Force
    $settings | ConvertTo-Json -Depth 20 | Set-Content -LiteralPath $settingsFile -Encoding utf8
    Write-Host 'Disabled launcher auto-updates so the custom runtime remains installed. Settings backup saved beside settings.'
}
