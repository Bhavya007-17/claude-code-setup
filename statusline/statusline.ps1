# Claude Code status line.
# Renders: <dir> | <model>  [CAVEMAN]
# The badge is delegated to the caveman plugin script so it stays in sync with
# the plugin's own hardening (reparse-point refusal, mode whitelist).

[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

$Esc = [char]27
$Dir = ''
$Model = ''

try {
    $Raw = [Console]::In.ReadToEnd()
    if ($Raw) {
        $Json = $Raw | ConvertFrom-Json
        if ($Json.workspace -and $Json.workspace.current_dir) {
            $Dir = Split-Path -Leaf $Json.workspace.current_dir
        }
        if ($Json.model -and $Json.model.display_name) {
            $Model = $Json.model.display_name
        }
    }
} catch {}

$Parts = @()
if ($Dir)   { $Parts += "${Esc}[38;5;39m$Dir${Esc}[0m" }
if ($Model) { $Parts += "${Esc}[38;5;245m$Model${Esc}[0m" }
if ($Parts.Count -gt 0) {
    [Console]::Write(($Parts -join " ${Esc}[38;5;240m|${Esc}[0m ") + ' ')
}

# Caveman badge. Absent flag file = no output, so this is a no-op when caveman
# is off.
$Badge = Join-Path $HOME '.claude\plugins\marketplaces\caveman\src\hooks\caveman-statusline.ps1'
if (Test-Path -LiteralPath $Badge) {
    try { & $Badge } catch {}
}
