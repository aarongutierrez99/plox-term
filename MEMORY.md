# MEMORY — el cerebro de plox-term

> Por qué cada decisión está donde está, con los números que la respaldan.
> Si future-yo se pregunta "¿por qué esto así?", la respuesta vive acá.
> Entorno original: Windows 10 · WSL2 Ubuntu · WezTerm · Zsh 5.9.

---

## 1. Rendimiento — lo que se midió (hyperfine, no estimaciones)

**Diagnóstico inicial:** el `.zshrc` en sí era rápido (~10 ms); el arranque de ~715 ms venía de otro lado.

| Causa aislada | Costo |
|---|---|
| `compinit` global (`/etc/zsh/zshrc`) con **auditoría completa en cada arranque** | ~230 ms (87%) |
| Amplificado por las **31 rutas `/mnt/c` de Windows** escaneadas sobre 9p | ×3 (config real llegaba a 900 ms, picos a 1600) |
| Cuerpo del `.zshrc` | ~10 ms (irrelevante) |

**Resultado:** arranque **~715 ms → ~335 ms** · resaltado **&lt;1 ms/tecla**.

### Las tres palancas
1. **`skip_global_compinit=1`** en `~/.zshenv` → mata el compinit con auditoría del global; corremos el nuestro **cacheado** (`compinit -C -d ~/.cache/zsh/zcompdump`, rebuild solo si el dump tiene >24 h).
2. **Poda del PATH de Windows** — `system32` y `Windows` tienen miles de archivos; abrir esos dirs sobre 9p en cada rehash/completado costaba ~90 ms y se multiplicaba por plugin. Se sacan del PATH y `explorer.exe`/`clip.exe` se llaman por **wrapper** (una función no se escanea). Se conservan solo VS Code, WezTerm y WindowsApps (dirs chicos). `code`, `winget`, `wezterm.exe` siguen llamables por nombre.
3. **fast-syntax-highlighting** (0.18–0.5 ms/tecla) en vez de `zsh-syntax-highlighting` (~2–3 ms y stat de rutas por tecla) + **autosuggestions asíncronas** (`ZSH_AUTOSUGGEST_USE_ASYNC=1`) con estrategia solo `history` (la estrategia `completion` corría el completador por tecla = lag).

> Decisión consciente: NO se hizo strip total de `/mnt/c` (llegaría a ~210 ms) para no perder `code`/`winget` por nombre. 335 ms con comodidad > 210 ms sin ella.

---

## 2. Color — un sistema, no colores sueltos

**Principio:** un hue = un rol, en TODO el entorno (prompt, `eza`, sintaxis, listados).

| Rol | ANSI |
|---|---|
| ubicación / directorio | azul (34) |
| VCS / rama | magenta (35) |
| acción / prompt / link | cyan (36) |
| válido / éxito / ejecutable | verde (32) |
| atención / warning / dirty | amarillo (33) |
| error / peligro | rojo (31) |
| metadato / fantasma | gris (90) |

**Clave de la conmutación de temas:** prompt (Starship), `eza` (`EZA_COLORS`/`LS_COLORS`), sintaxis (F-Sy-H) y autosuggestions usan **índices/nombres ANSI**, no hex fijos. Como los 16 colores ANSI los define el tema activo de WezTerm, **cambiar el tema recolorea todo junto**. Ese es el truco de que "cambia todo de una".

Contraste verificado (fondo Tokyo Night `#1a1b26`): todos los tokens del núcleo pasan WCAG AA/AAA. El gris `#565f89`/`fg=8` "falla" AA a propósito: el texto fantasma debe recederse.

---

## 3. Temas (15)

Registro en `wezterm/wezterm.lua` (tabla `themes` + lista `order`). Cada tema define `fg/bg/cursor/sel`, `ansi[8]`, `brights[8]`, colores de tab y `opacity`. Cambio en vivo con `window:set_config_overrides` (sin reiniciar) + persistencia en `~/.wezterm-theme.txt` (lado Windows).

- **Neón/hacker** (fondo translúcido, se ve maximizado): Hacker Green, Matrix Black (negro puro), Neon Cyber, Synthwave 84, Blood Dragon.
- **Premium** (sólidos, legibilidad 12 h): Tokyo Night, Dracula, Rose Pine, Kanagawa Wave, Everforest, Monokai Pro, Ayu Mirage, Catppuccin Mocha, Nord, Gruvbox.

Nota Windows: el **blur acrílico** (`win32_system_backdrop`) se **desactiva al maximizar** (limitación del SO). Por eso los temas translúcidos usan **opacity plana** (funciona maximizado), no acrílico.

---

## 4. Tipografía / WezTerm

- **JetBrains Mono Nerd Font** — elegida por desambiguación (`Il1`, `O0`), altura-x alta. Ligaduras `=> != ->` ON (deliberado).
- `line_height = 1.15` (respiro vertical), cursor cyan suave (era neón, único color fuera de paleta), `INTEGRATED_BUTTONS|RESIZE` (chrome limpio con botones), panes inactivos atenuados, bell off, WebGpu + 144 fps.

---

## 5. Portabilidad (para servers Linux puros)

- Todo lo de WSL está tras `if [[ -d /mnt/c ]]` → en Linux puro se omite solo.
- Usuario de Windows **detectado en runtime** (glob de `/mnt/c/Users/*`), no hardcodeado.
- Plugins y binarios **adaptativos**: se activan solo si existen; `bat`/`batcat` y `fd`/`fdfind` según distro.
- La fuente la dibuja el emulador (máquina local), no el server remoto.

---

## 6. Trampas conocidas

- El warning `can't change option: zle` solo aparece con `zsh -c` **sin terminal**; en una sesión real (pty) no existe. No es un bug de la config.
- Glifos Nerd Font altos (ej. `󰊢`) pueden no dibujarse; usar los del rango powerline (ej. rama `` U+E0A0) que están en toda Nerd Font.
- `compinit -C` cacheado no rehace el dump; si agregás completions nuevas, borrá `~/.cache/zsh/zcompdump` (o esperá 24 h al rebuild automático).
