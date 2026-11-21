# Installs this Claude Code setup into ~/.claude (Windows PowerShell 5.1+).
# Any file it would replace is first backed up as <file>.bak-<timestamp>.
# settings.json is never touched; see settings.example.json and the README.
param(
    [switch]$SkipPlugins
)

$ErrorActionPreference = 'Stop'
$Repo = $PSScriptRoot
$Dest = Join-Path $HOME '.claude'
$Stamp = Get-Date -Format 'yyyyMMdd-HHmmss'

function Install-File([string]$Rel, [string]$Target) {
    $Src = Join-Path $Repo $Rel
    $Dst = Join-Path $Dest $Target
    New-Item -ItemType Directory -Force -Path (Split-Path -Parent $Dst) | Out-Null
    if (Test-Path -LiteralPath $Dst) {
        Copy-Item -LiteralPath $Dst -Destination "$Dst.bak-$Stamp"
        Write-Host "backed up $Dst"
    }
    Copy-Item -LiteralPath $Src -Destination $Dst -Force
    Write-Host "installed $Dst"
}

Install-File 'CLAUDE.md'                'CLAUDE.md'
Install-File 'rules\common\core.md'     'rules\common\core.md'
Install-File 'agents\oracle.md'         'agents\oracle.md'
Install-File 'statusline\statusline.ps1' 'statusline.ps1'

if ($SkipPlugins) {
    Write-Host 'skipping plugins (-SkipPlugins)'
} elseif (-not (Get-Command claude -ErrorAction SilentlyContinue)) {
    Write-Warning 'claude CLI not on PATH; skipping plugins. Install Claude Code, then rerun.'
} else {
    $Marketplaces = @(
        'anthropics/claude-plugins-official',
        'JuliusBrussee/caveman',
        'olsenbrands/fable-foreman'
    )
    $Plugins = @(
        'superpowers@claude-plugins-official',
        'frontend-design@claude-plugins-official',
        'commit-commands@claude-plugins-official',
        'ralph-loop@claude-plugins-official',
        'security-guidance@claude-plugins-official',
        'playwright@claude-plugins-official',
        'caveman@caveman',
        'fable-foreman@fable-foreman'
    )
    foreach ($M in $Marketplaces) { claude plugin marketplace add $M }
    $Failed = @()
    foreach ($P in $Plugins) {
        claude plugin install $P --scope user
        if ($LASTEXITCODE -ne 0) { $Failed += $P }
    }
    if ($Failed.Count -gt 0) { Write-Warning ("plugins that failed to install: " + ($Failed -join ', ')) }
}

$StatusPath = (Join-Path $Dest 'statusline.ps1') -replace '\\', '\\'
Write-Host ''
Write-Host 'Done. To enable the status line, add this to ~/.claude/settings.json:'
Write-Host ('  "statusLine": { "type": "command", "command": "powershell -NoProfile -ExecutionPolicy Bypass -File \"' + $StatusPath + '\"", "padding": 0 }')
Write-Host 'Restart Claude Code to load everything.'
