param([string]$Root)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

if (-not $Root -or -not (Test-Path $Root)) {
    $Root = Split-Path -Parent $PSScriptRoot
}

$srcDir   = Join-Path $Root 'src'
$buildDir = Join-Path $Root 'build'
$base     = Join-Path $Root 'assets\base.p8'
$outCart  = Join-Path $buildDir 'mygame.p8'
$concat   = Join-Path $buildDir '_concat.lua'

# Explicit order
$files = @(
    (Join-Path $srcDir 'systems\player.lua'),
    (Join-Path $srcDir 'scenes\game.lua'),
    (Join-Path $srcDir 'main.lua')
)

$pt = Get-Command p8tool.exe -ErrorAction SilentlyContinue
if (-not $pt) { throw "p8tool.exe not found in PATH" }

New-Item -ItemType Directory -Force $buildDir | Out-Null
Copy-Item $base $outCart -Force

# Concatenate Lua content
$nl  = "`r`n"
$lua = ''
foreach ($f in $files) {
    $lua += (Get-Content -Raw $f) + $nl + $nl
}

# >>> CHANGE: write concatenated Lua WITHOUT UTF-8 BOM <<<
$utf8NoBom = New-Object System.Text.UTF8Encoding($false)
[System.IO.File]::WriteAllText($concat, $lua, $utf8NoBom)

# Build using the concat file
& $pt.Source build $outCart --gfx $base --gff $base --map $base --sfx $base --music $base --lua $concat
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }

$pico = 'C:\Program Files (x86)\PICO-8\pico8.exe'
if (-not (Test-Path $pico)) { $pico = 'C:\Program Files\PICO-8\pico8.exe' }
& "$pico" $outCart
exit $LASTEXITCODE
