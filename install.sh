#!/usr/bin/env bash
# Installs this Claude Code setup into ~/.claude (macOS, Linux, WSL, Git Bash).
# Any file it would replace is first backed up as <file>.bak-<timestamp>.
# settings.json is never touched; see settings.example.json and the README.
# The status line script is PowerShell, so it is only installed by install.ps1.
# Usage: ./install.sh [--skip-plugins]
set -u

REPO="$(cd "$(dirname "$0")" && pwd)"
DEST="$HOME/.claude"
STAMP="$(date +%Y%m%d-%H%M%S)"

install_file() {
  local src="$REPO/$1" dst="$DEST/$2"
  mkdir -p "$(dirname "$dst")"
  if [ -e "$dst" ]; then
    cp "$dst" "$dst.bak-$STAMP"
    echo "backed up $dst"
  fi
  cp "$src" "$dst"
  echo "installed $dst"
}

install_file CLAUDE.md            CLAUDE.md
install_file rules/common/core.md rules/common/core.md
install_file agents/oracle.md     agents/oracle.md

if [ "${1:-}" = "--skip-plugins" ]; then
  echo "skipping plugins (--skip-plugins)"
elif ! command -v claude >/dev/null 2>&1; then
  echo "warning: claude CLI not on PATH; skipping plugins. Install Claude Code, then rerun." >&2
else
  for m in anthropics/claude-plugins-official JuliusBrussee/caveman olsenbrands/fable-foreman; do
    claude plugin marketplace add "$m"
  done
  failed=""
  for p in \
    superpowers@claude-plugins-official \
    frontend-design@claude-plugins-official \
    commit-commands@claude-plugins-official \
    ralph-loop@claude-plugins-official \
    security-guidance@claude-plugins-official \
    playwright@claude-plugins-official \
    caveman@caveman \
    fable-foreman@fable-foreman; do
    claude plugin install "$p" --scope user || failed="$failed $p"
  done
  [ -n "$failed" ] && echo "warning: plugins that failed to install:$failed" >&2
fi

echo
echo "Done. Restart Claude Code to load everything."
