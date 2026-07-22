#!/usr/bin/env bash
# plox-term · sync.sh — trae el wezterm.lua de Windows de vuelta al repo.
# Los configs de shell están symlinkeados, así que NO necesitan sync.
set -uo pipefail
REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]:-$0}")" && pwd)"
c_ok=$'\033[1;32m'; c_warn=$'\033[1;33m'; c_end=$'\033[0m'

if [[ ! -d /mnt/c ]]; then
  printf '%s!!%s no es WSL; nada que sincronizar (shell está symlinkeado).\n' "$c_warn" "$c_end"; exit 0
fi
for uh in /mnt/c/Users/*/; do
  if [[ -f "$uh/.wezterm.lua" ]]; then
    cp "$uh/.wezterm.lua" "$REPO_DIR/wezterm/wezterm.lua"
    printf '%sok%s wezterm.lua ← %s\n' "$c_ok" "$c_end" "$uh"
    printf '   ahora: cd %s && git add -A && git commit && git push\n' "$REPO_DIR"
    exit 0
  fi
done
printf '%s!!%s no encontré .wezterm.lua en Windows.\n' "$c_warn" "$c_end"
