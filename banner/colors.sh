#!/usr/bin/env bash
# plox-term · banner/colors.sh
# Colores de MARCA del banner. Son FIJOS a propósito: la identidad (logo verde,
# título rojo) no sigue el tema de WezTerm — al revés que el resto del entorno,
# que sí es color-por-rol sobre ANSI. Un solo lugar donde tocar los hex.

PLOX_LOGO_HEX="3ff58f"   # verde  — el logo (logo.txt)
PLOX_TITLE_HEX="ff5555"  # rojo   — el título PLOXEM (title.txt)

# plox_fg RRGGBB  → emite la secuencia truecolor de foreground para ese hex.
plox_fg() {
  local hex="${1#\#}"
  printf '\033[38;2;%d;%d;%dm' "0x${hex:0:2}" "0x${hex:2:2}" "0x${hex:4:2}"
}

PLOX_RESET=$'\033[0m'
