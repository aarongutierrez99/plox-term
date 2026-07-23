#!/usr/bin/env bash
# plox-term · banner/banner.sh
# Pinta el logo (logo.txt) en verde de marca y el título PLOXEM (title.txt) en
# rojo, con un "cascade reveal" tipo secuencia de arranque hacker.
# Lee los .txt: editás el arte ahí, no acá.
#
# Velocidad (sin sacrificar el arranque):
#   · anima solo si la SALIDA es una terminal (pipe/no-TTY → instantáneo).
#   · la demora entre líneas usa un FIFO + `read -t` → sin `sleep`, sin un fork
#     por línea, y SIN depender de stdin (el "ruido" de arranque del emulador
#     no la interrumpe).
# Tuneo:
#   PLOX_BANNER_ANIM=none   → sin animación (instantáneo)
#   PLOX_BANNER_DELAY=0.007 → segundos por línea (default abajo)
set -u

HERE="$(cd "$(dirname "${BASH_SOURCE[0]:-$0}")" && pwd)"
# shellcheck source=/dev/null
source "$HERE/colors.sh"

LOGO="$HERE/logo.txt"
TITLE="$HERE/title.txt"

ANIM="${PLOX_BANNER_ANIM:-cascade}"
DELAY="${PLOX_BANNER_DELAY:-0.007}"

# Animar solo si stdout es una terminal (y no se pidió apagar).
_anim=0
[[ -t 1 && "$ANIM" != "none" ]] && _anim=1

# nap sin forks: un FIFO abierto read-write y sin escritor → `read -t` espera el
# timeout y vuelve (no hay EOF porque tenemos abierta la punta de escritura).
_napfd=""
if (( _anim )); then
  _f="$(mktemp -u 2>/dev/null || true)"
  if [[ -n "$_f" ]] && mkfifo "$_f" 2>/dev/null; then
    if exec {_napfd}<>"$_f" 2>/dev/null; then rm -f "$_f" 2>/dev/null; else _napfd=""; rm -f "$_f" 2>/dev/null; fi
  fi
fi
_cleanup(){ [[ -n "$_napfd" ]] && exec {_napfd}>&- 2>/dev/null; }
trap '_cleanup' EXIT

_nap(){
  (( _anim )) || return 0
  if [[ -n "$_napfd" ]]; then
    read -t "$1" -u "$_napfd" _ 2>/dev/null || true
  else
    sleep "$1" 2>/dev/null || true
  fi
}

# print_block ARCHIVO HEX → pinta el bloque coloreado, línea por línea.
print_block(){
  local file="$1" hex="$2" line
  [[ -f "$file" ]] || return 0
  plox_fg "$hex"
  while IFS= read -r line || [[ -n "$line" ]]; do
    printf '%s\n' "$line"
    _nap "$DELAY"
  done < "$file"
  printf '%s' "$PLOX_RESET"
}

printf '\n'
print_block "$LOGO"  "$PLOX_LOGO_HEX"
printf '\n\n'                 # 2 líneas en blanco entre logo y título
print_block "$TITLE" "$PLOX_TITLE_HEX"
printf '\n'
