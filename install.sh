#!/usr/bin/env bash
# =============================================================================
#  plox-term · install.sh
#  Instala dependencias, respalda tus configs y enlaza las de plox-term.
#  Idempotente: podés correrlo las veces que quieras.
#
#  Uso:
#    git clone https://github.com/aarongutierrez99/plox-term ~/plox-term
#    ~/plox-term/install.sh
#  o directo:
#    bash <(curl -fsSL https://raw.githubusercontent.com/aarongutierrez99/plox-term/main/install.sh)
# =============================================================================
set -uo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]:-$0}")" && pwd)"
# Si se corrió por curl, clonar primero
if [[ ! -f "$REPO_DIR/shell/zshrc" ]]; then
  REPO_DIR="$HOME/plox-term"
  if [[ ! -d "$REPO_DIR" ]]; then
    echo ":: clonando plox-term en $REPO_DIR"
    git clone --depth 1 https://github.com/aarongutierrez99/plox-term "$REPO_DIR" || { echo "!! no se pudo clonar"; exit 1; }
  fi
fi

TS="$(date +%Y%m%d-%H%M%S)"
c_info=$'\033[1;36m'; c_ok=$'\033[1;32m'; c_warn=$'\033[1;33m'; c_end=$'\033[0m'
info(){ printf '%s::%s %s\n' "$c_info" "$c_end" "$*"; }
ok(){   printf '%sok%s %s\n' "$c_ok" "$c_end" "$*"; }
warn(){ printf '%s!!%s %s\n' "$c_warn" "$c_end" "$*"; }

backup(){ [[ -e "$1" || -L "$1" ]] && cp -a "$1" "$1.bak-$TS" 2>/dev/null && info "backup $1 → $1.bak-$TS"; return 0; }

# --------------------------------------------------------------------- deps ---
install_deps(){
  info "Instalando dependencias…"
  if command -v apt >/dev/null; then
    sudo apt-get update -y || warn "apt update falló"
    for p in zsh git curl unzip fontconfig fzf bat fd-find ripgrep zsh-autosuggestions; do
      dpkg -s "$p" >/dev/null 2>&1 || sudo apt-get install -y "$p" || warn "no se pudo instalar $p"
    done
    dpkg -s eza >/dev/null 2>&1 || sudo apt-get install -y eza 2>/dev/null || warn "eza no está en apt de esta versión (instalá manual: https://github.com/eza-community/eza)"
  elif command -v pacman >/dev/null; then
    sudo pacman -Sy --needed --noconfirm zsh git curl unzip fontconfig fzf bat fd ripgrep eza zsh-autosuggestions || warn "pacman falló en algún paquete"
  elif command -v dnf >/dev/null; then
    sudo dnf install -y zsh git curl unzip fontconfig fzf bat fd-find ripgrep eza zsh-autosuggestions || warn "dnf falló en algún paquete"
  else
    warn "Gestor de paquetes no reconocido. Instalá manual: zsh git curl fzf bat fd ripgrep eza zsh-autosuggestions"
  fi

  command -v starship >/dev/null || { info "starship…"; curl -fsSL https://starship.rs/install.sh | sh -s -- -y || warn "starship falló"; }
  command -v zoxide   >/dev/null || { info "zoxide…";   curl -fsSL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh || warn "zoxide falló"; }

  local fsh="$HOME/.local/share/fast-syntax-highlighting"
  [[ -d "$fsh" ]] || { info "fast-syntax-highlighting…"; git clone --depth 1 https://github.com/zdharma-continuum/fast-syntax-highlighting.git "$fsh" || warn "F-Sy-H falló"; }

  [[ -d "$HOME/.nvm" ]] || { info "nvm…"; curl -fsSL https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | PROFILE=/dev/null bash || warn "nvm falló"; }
}

# ------------------------------------------------------------------- links ---
link_configs(){
  info "Enlazando configs (con backup)…"
  mkdir -p "$HOME/.config" "$HOME/.cache/zsh"
  backup "$HOME/.zshrc";                ln -sf "$REPO_DIR/shell/zshrc"         "$HOME/.zshrc"
  backup "$HOME/.zshenv";               ln -sf "$REPO_DIR/shell/zshenv"        "$HOME/.zshenv"
  backup "$HOME/.config/starship.toml"; ln -sf "$REPO_DIR/shell/starship.toml" "$HOME/.config/starship.toml"
  # Si bajaste el repo como .zip en vez de clonarlo, los permisos de ejecución se
  # pierden y el banner de bienvenida no aparecería (falla en silencio).
  chmod +x "$REPO_DIR"/banner/*.sh 2>/dev/null
  ok "~/.zshrc, ~/.zshenv, ~/.config/starship.toml enlazados a plox-term"
}

# ----------------------------------------------------------------- wezterm ---
install_wezterm(){
  [[ -d /mnt/c ]] || { info "No es WSL → omito WezTerm (config del emulador)"; return; }
  local wh=""
  for uh in /mnt/c/Users/*/; do [[ -d "$uh/AppData/Local/Microsoft/WindowsApps" ]] && wh="${uh%/}" && break; done
  [[ -n "$wh" ]] || { warn "No encontré el home de Windows; copiá wezterm/wezterm.lua a mano"; return; }
  backup "$wh/.wezterm.lua"
  cp "$REPO_DIR/wezterm/wezterm.lua" "$wh/.wezterm.lua" && ok "wezterm.lua → $wh/.wezterm.lua"
}

# -------------------------------------------------------------------- font ---
install_font(){ info "Fuente (JetBrainsMono Nerd Font)…"; bash "$REPO_DIR/fonts/install.sh" || warn "instalación de fuente omitida (ver fonts/README)"; }

# ------------------------------------------------------------------- shell ---
set_shell(){
  local zsh; zsh="$(command -v zsh || true)"
  [[ -n "$zsh" ]] || { warn "zsh no está instalado"; return; }
  [[ "$SHELL" == "$zsh" ]] && { ok "zsh ya es tu shell por defecto"; return; }
  info "Poniendo zsh como shell por defecto (puede pedir contraseña)…"
  chsh -s "$zsh" || warn "chsh falló; hacelo manual: chsh -s $zsh"
}

main(){
  echo "${c_info}plox-term${c_end} · instalador  (repo: $REPO_DIR)"
  install_deps
  link_configs
  install_wezterm
  install_font
  set_shell
  echo
  ok "Listo. Abrí una terminal nueva o corré: exec zsh"
  if [[ -d /mnt/c ]]; then
    info "WSL: cerrá WezTerm por completo y volvé a abrirlo (no alcanza con recargar)."
    info "  · Ctrl+Shift+Space  elegí entre los 15 temas   · F12 los cicla"
    info "  · La ventana recuerda dónde la dejaste y abre siempre del mismo tamaño."
    info "  · ¿Se abre más grande que tu pantalla? Cambiá WIN_COLS/WIN_ROWS arriba"
    info "    de todo en wezterm/wezterm.lua (sección Geometría) y reinstalá."
  fi
}
main "$@"
