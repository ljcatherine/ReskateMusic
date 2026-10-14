param(
    [string]$CacheRoot = (Join-Path $env:LOCALAPPDATA 'ReskateMusic\build-cache'),
    [switch]$TestOnly
)
$ErrorActionPreference = 'Stop'
$repoRoot = Split-Path $PSScriptRoot -Parent
$upstreamCommit = '6c45e9666dcdea6577248f6ab7f3111de48b6039'
function Invoke-Checked {
    param([string]$Command, [string[]]$Arguments)
    & $Command @Arguments
    if ($LASTEXITCODE -ne 0) { throw "$Command failed with exit code $LASTEXITCODE" }
}
Invoke-Checked -Command cmake -Arguments @('-S', (Join-Path $repoRoot 'tests'), '-B', (Join-Path $repoRoot 'build\tests'), '-G', 'Visual Studio 17 2022', '-A', 'x64')
Invoke-Checked -Command cmake -Arguments @('--build', (Join-Path $repoRoot 'build\tests'), '--config', 'Release')
Invoke-Checked -Command ctest -Arguments @('--test-dir', (Join-Path $repoRoot 'build\tests'), '-C', 'Release', '--output-on-failure')
if ($TestOnly) { return }
$checkout = Join-Path $CacheRoot "reskate-$upstreamCommit"
New-Item -ItemType Directory -Force $CacheRoot | Out-Null
if (-not (Test-Path -LiteralPath (Join-Path $checkout '.git'))) {
    Invoke-Checked -Command git -Arguments @('clone', 'https://github.com/Dingo-Shenanigans/ReSkate.git', $checkout)
    Invoke-Checked -Command git -Arguments @('-C', $checkout, 'checkout', '--detach', $upstreamCommit)
}
$actualCommit = & git -C $checkout rev-parse HEAD
if ($LASTEXITCODE -ne 0 -or $actualCommit -ne $upstreamCommit) { throw 'Build cache is not at the pinned upstream commit.' }
$sourceRoot = Join-Path $repoRoot 'src'
Get-ChildItem -LiteralPath $sourceRoot -Recurse -File | ForEach-Object {
    $relative = $_.FullName.Substring($sourceRoot.Length + 1)
    $destination = Join-Path $checkout $relative
    New-Item -ItemType Directory -Force (Split-Path $destination) | Out-Null
    Copy-Item -LiteralPath $_.FullName -Destination $destination -Force
}
Push-Location $checkout
try {
    Invoke-Checked -Command cmake -Arguments @('--preset', 'vs2022-x64')
    Invoke-Checked -Command cmake -Arguments @('--build', '--preset', 'release', '--target', 'dingosdk_runtime', '--parallel', '8')
} finally { Pop-Location }
$package = Join-Path $repoRoot 'dist\ReskateMusic'
New-Item -ItemType Directory -Force $package | Out-Null
Copy-Item -LiteralPath (Join-Path $checkout 'build\vs2022-x64\Release\ReSkate.dll') -Destination $package -Force
Copy-Item -LiteralPath (Join-Path $PSScriptRoot 'Install.ps1') -Destination $package -Force
Copy-Item -LiteralPath (Join-Path $repoRoot 'LICENSE') -Destination $package -Force
Copy-Item -LiteralPath (Join-Path $repoRoot 'README.MD') -Destination (Join-Path $package 'README.txt') -Force
Compress-Archive -Path $package -DestinationPath (Join-Path $repoRoot 'dist\ReskateMusic-0.1.zip') -Force
# Supply complete corresponding source, including the pinned dependencies.
Invoke-Checked -Command tar -Arguments @('-a', '-c', '-f', (Join-Path $repoRoot 'dist\ReskateMusic-source.zip'), '--exclude=.git', '--exclude=build', '-C', $checkout, '.')
Write-Host "Build and source packages are in $(Join-Path $repoRoot 'dist')"
