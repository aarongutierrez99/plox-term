<h1 align="center">plox-term</h1>

<p align="center">
  <b>Una terminal WSL/Zsh premium, rápida y con 15 temas conmutables en vivo.</b><br>
  <sub>Tokyo Night · JetBrains Mono · Starship · WezTerm — arranque ~2× más rápido, tipeo &lt;1 ms.</sub>
</p>

---

## ✨ Qué es

Mi entorno de terminal completo, empaquetado para **no perderlo nunca** y **reinstalarlo con un comando** en cualquier WSL o servidor Linux. No es "otro dotfiles": está medido, documentado y pensado para trabajar 12 h sin fatiga.

- ⚡ **Rápido de verdad** — arranque **~715 ms → ~335 ms** y tipeo **&lt;1 ms/tecla** (benchmarks en [`MEMORY.md`](MEMORY.md)).
- 🎨 **15 temas en vivo** estilo Termius — `Ctrl+Shift+Space` y cambia **todo** (fondo, texto, archivos, prompt, sintaxis, pestañas).
- 🧠 **Color por rol** — un solo lenguaje cromático en prompt, `eza`, sintaxis y listados, sobre la paleta ANSI (por eso el tema recolorea todo junto).
- 🔌 **Portable** — en WSL activa el interop de Windows; en un server Linux puro lo omite solo. El mismo `.zshrc` corre en los dos.

## 🚀 Instalación

```bash
git clone https://github.com/aarongutierrez99/plox-term ~/plox-term
~/plox-term/install.sh
```

o de una línea:

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/aarongutierrez99/plox-term/main/install.sh)
```

El instalador **respalda** cualquier config previa (`*.bak-<fecha>`), instala dependencias, enlaza los configs y pone `zsh` por defecto. Reabrí la terminal y listo.

## 🎨 Temas (15)

| Neón / Hacker | Premium / Diseñador |
|---|---|
| Hacker Green · Matrix Black | Tokyo Night · Dracula |
| Neon Cyber · Synthwave 84 | Rose Pine · Kanagawa Wave |
| Blood Dragon | Everforest · Monokai Pro |
| | Ayu Mirage · Catppuccin Mocha · Nord · Gruvbox |

**Atajos** (WezTerm): `Ctrl+Shift+Space` selector buscable · `F12` ciclar · el elegido se recuerda.

Agregar un tema: copiá un bloque en `wezterm/wezterm.lua` (tabla `themes`), sumá el nombre a `order`, guardá.

## 🧰 Qué incluye

| Capa | Herramientas |
|---|---|
| Shell | Zsh · Starship · fast-syntax-highlighting · zsh-autosuggestions (async) |
| CLI | eza · zoxide · fzf · bat · fd · ripgrep |
| Runtime | NVM (carga perezosa) |
| Terminal | WezTerm (WebGpu, 15 temas, tab bar custom) |
| Fuente | JetBrains Mono Nerd Font |

## 🔁 Actualizar tras cambios

Los configs de Linux están **enlazados** al repo, así que editás normal y:

```bash
cd ~/plox-term
./sync.sh          # trae tu wezterm.lua de Windows de vuelta al repo
git add -A && git commit -m "tweak: ..." && git push
```

## 🔤 Sobre la fuente

La fuente la dibuja **el emulador**, no el servidor:
- **WSL + WezTerm** → se instala en **Windows** (`fonts/install.ps1`, o `fonts/install.sh` la baja e instala).
- **Server remoto por SSH** → la fuente ya la tiene **tu máquina local**; el server no la necesita.

## ↩️ Desinstalar

```bash
~/plox-term/uninstall.sh    # restaura los backups más recientes y quita los symlinks
```

## 📄 Licencia

MIT — ver [`LICENSE`](LICENSE).
