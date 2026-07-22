#!/usr/bin/env bash
# plox-term · uninstall.sh — quita los symlinks y restaura el backup más reciente.
set -uo pipefail
c_ok=$'\033[1;32m'; c_warn=$'\033[1;33m'; c_end=$'\033[0m'
ok(){ printf '%sok%s %s\n' "$c_ok" "$c_end" "$*"; }
warn(){ printf '%s!!%s %s\n' "$c_warn" "$c_end" "$*"; }

restore(){
  local target="$1"
  [[ -L "$target" ]] && rm -f "$target"          # sacar el symlink de plox-term
  local last
  last="$(ls -1dt "$target".bak-* 2>/dev/null | head -1 || true)"
  if [[ -n "$last" ]]; then
    cp -a "$last" "$target" && ok "restaurado $target ← $(basename "$last")"
  else
    warn "sin backup para $target (quedó sin archivo)"
  fi
}

restore "$HOME/.zshrc"
restore "$HOME/.zshenv"
restore "$HOME/.config/starship.toml"

if [[ -d /mnt/c ]]; then
  for uh in /mnt/c/Users/*/; do
    [[ -f "$uh/.wezterm.lua" ]] && restore "$uh/.wezterm.lua" && break
  done
fi

echo
ok "Listo. Abrí una terminal nueva. (El repo ~/plox-term sigue intacto.)"
