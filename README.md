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

---

## 🚀 Instalación paso a paso

### 🅰️ Desde cero en Windows (no tenés NADA instalado)

**1 · Instalá WSL2 + Ubuntu.** Abrí **PowerShell como Administrador** (botón derecho → "Ejecutar como administrador") y pegá:

```powershell
wsl --install
```

Reiniciá la PC. Al volver, Ubuntu se abre solo y te pide crear un **usuario y contraseña** (anotá la contraseña, la vas a usar para instalar cosas).

**2 · Instalá WezTerm** (la terminal). En PowerShell normal:

```powershell
winget install wez.wezterm
```

**3 · Instalá plox-term.** Abrí **Ubuntu** desde el menú Inicio y pegá:

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/aarongutierrez99/plox-term/main/install.sh)
```

Te va a pedir tu contraseña de Ubuntu (para instalar los programas). Instala todo, respalda lo que hubiera, y deja la fuente lista en Windows.

**4 · Listo.** Cerrá Ubuntu, abrí **WezTerm** desde el menú Inicio — arranca directo en tu terminal nueva, con todo aplicado. Probá `Ctrl+Shift+Space` para cambiar de tema. 🎉

---

### 🅱️ Ya tenés WSL + una terminal

```bash
git clone https://github.com/aarongutierrez99/plox-term ~/plox-term
~/plox-term/install.sh
```

o de una sola línea:

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/aarongutierrez99/plox-term/main/install.sh)
```

Reabrí la terminal (o `exec zsh`) y reiniciá WezTerm.

---

### 🐧 Servidor Linux por SSH (sin Windows)

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/aarongutierrez99/plox-term/main/install.sh)
```

Detecta que no es WSL y omite WezTerm/Windows. La fuente ya la tiene **tu máquina local** (la terminal desde la que te conectás), no el server.

> El instalador **siempre respalda** tu config previa como `*.bak-<fecha>` antes de tocar nada. Reversible con `~/plox-term/uninstall.sh`.

---

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
