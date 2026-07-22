#!/usr/bin/env bash
# plox-term · fonts/install.sh — JetBrains Mono Nerd Font.
#   WSL   → instala en Windows (donde WezTerm dibuja) vía install.ps1
#   Linux → instala en ~/.local/share/fonts
set -uo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]:-$0}")" && pwd)"
URL="https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.zip"
c_ok=$'\033[1;32m'; c_warn=$'\033[1;33m'; c_end=$'\033[0m'
ok(){ printf '%sok%s %s\n' "$c_ok" "$c_end" "$*"; }
warn(){ printf '%s!!%s %s\n' "$c_warn" "$c_end" "$*"; }

if [[ -d /mnt/c ]]; then
  # La fuente va en Windows: WezTerm la dibuja desde ahí.
  if command -v powershell.exe >/dev/null; then
    powershell.exe -NoProfile -ExecutionPolicy Bypass -File "$(wslpath -w "$HERE/install.ps1")" \
      && ok "Fuente instalada en Windows" || warn "Corré fonts/install.ps1 a mano en Windows"
  else
    warn "No pude invocar powershell.exe; instalá la fuente a mano (fonts/install.ps1)"
  fi
  exit 0
fi

# Linux local
command -v curl >/dev/null || { warn "falta curl"; exit 0; }
DEST="$HOME/.local/share/fonts/JetBrainsMonoNerd"
TMP="$(mktemp -d)"
if curl -fsSL "$URL" -o "$TMP/JBM.zip"; then
  mkdir -p "$DEST"
  unzip -oq "$TMP/JBM.zip" -d "$DEST" '*.ttf' 2>/dev/null || unzip -oq "$TMP/JBM.zip" -d "$DEST"
  command -v fc-cache >/dev/null && fc-cache -f "$DEST" >/dev/null 2>&1
  ok "JetBrains Mono Nerd Font → $DEST"
else
  warn "No pude bajar la fuente"
fi
rm -rf "$TMP"
