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
- `font_size = 10` — bajado de 11.5 porque el default obligaba a hacer `Ctrl+-` **dos veces en cada ventana**. La barra de pestañas va a 9 para no quedar más grande que el cuerpo.
- `line_height = 1.15` (respiro vertical), cursor cyan suave (era neón, único color fuera de paleta), `INTEGRATED_BUTTONS|RESIZE` (chrome limpio con botones), panes inactivos atenuados, bell off, WebGpu + 144 fps.
- `window_frame` se arma por tema con **`frame_for(t)`** (la misma función para el arranque y para el cambio en vivo), así el marco puede seguir el color del tema. Hoy el borde va en **0**: se probó un neón del color de acento y se descartó.
- **Tamaño de ventana FIJO** (`initial_cols/rows` = 174×39), no "el último usado". Guardar el último tamaño se rompe con el maximizado: quedaría guardada la medida maximizada y la ventana siguiente, que nace flotante, se pasaría de la pantalla. WezTerm **no expone "¿estoy maximizado?"** (`get_dimensions()` solo trae `is_full_screen`), así que desde Lua no hay forma de filtrarlo. Con la medida clavada, maximizar sale gratis. La **posición** sí se recuerda → §8.

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
- **`wezterm.lua` vive DOS veces.** La copia **viva** es la de Windows (`C:\Users\<vos>\.wezterm.lua`) — esa es la que WezTerm mira. La del repo es solo el espejo versionado. Editar el repo y guardar **no cambia nada** hasta copiarla a Windows (`install.sh` la despliega; `sync.sh` la trae de vuelta). Costó un rato de "cambio la fuente y no pasa nada".
- **El filo gris de 1 px alrededor de la ventana es del SO**, no de WezTerm: lo dibuja Windows por tener `RESIZE` en `window_decorations`. Con el borde de WezTerm en 0 igual queda. Solo se va sacando `RESIZE` (y ahí perdés redimensionar arrastrando) o con `NONE`. Se eligió **conservar el resize** y bancar el píxel.
- **Para la posición de una ventana, `GetWindowRect` es la trampa; lo correcto es `GetWindowPlacement`.** Medido con una ventana de descarte: normal, las dos coinciden (389,215); **maximizada, `GetWindowRect` devuelve `-8,-8`** y `rcNormalPosition` sigue en 389,215. Con la primera, maximizar antes de cerrar dejaba guardada una posición fuera de pantalla. `rcNormalPosition` es la posición *restaurada* y vale también minimizada.
- **Un ejecutable de Windows lanzado desde WSL no hereda el entorno de Windows**: `USERPROFILE` viene vacío y `Environment.GetFolderPath(UserProfile)` devuelve `""`, así que el archivo termina en cualquier lado. Lanzado desde `wezterm-gui` (proceso Windows de verdad) anda bien — es un artefacto de probar desde bash, no un bug.
- **`timeout.exe /T n` falla al toque si le redirigís la entrada** (`ERROR: Input redirection is not supported`), así que un "esperá 8 segundos" en un script se evapora y medís antes de tiempo. Para esperar de verdad desde bash: `PING.EXE -n <n+1> 127.0.0.1 >/dev/null`. Costó un falso negativo entero ("el vigía no escribe" cuando sí escribía).
- **La animación del banner no debe atarse a `stdin`.** La 1ª versión usaba `read -t` sobre la terminal para demorar *y* permitir saltear con una tecla; al arrancar, el emulador manda ruido a stdin (respuestas a queries) y la animación se salteaba **siempre**. Se pasó a demorar con un **FIFO** (`read -t` sobre un fd sin escritor, sin fork por línea) y a decidir si animar según **stdout** (`-t 1`).

---

## 7. Banner de bienvenida

- `banner/banner.sh` **lee** `logo.txt` y `title.txt` — el arte se edita en los `.txt`, no en el script. Los hex viven en `banner/colors.sh` y son **fijos** (identidad de marca): a diferencia del resto del entorno, **no** siguen el tema.
- **Sale una sola vez por sesión.** El zshrc saluda solo si la shell es interactiva, con TTY y sin `PLOX_NOGREET`; después **exporta** esa marca, así subshells y `exec zsh` quedan mudos. Los **splits** la reciben inyectada desde `wezterm.lua` (`SplitHorizontal`/`SplitVertical` con `set_environment_variables`) — por eso una ventana o pestaña nueva sí saluda y el split no.
- **Animación** en cascada (línea por línea), sin `sleep` ni un fork por línea. Se apaga con `PLOX_BANNER_ANIM=none` y se regula con `PLOX_BANNER_DELAY`. En pipe/no-TTY imprime instantáneo, así no ensucia ni demora los scripts.
- Se evaluó **fastfetch** debajo del banner (~34 ms medidos) y se **descartó**: se quería solo el banner.

---

## 8. La ventana recuerda su posición

**El problema:** WezTerm puede **escribir** la posición de una ventana (`position` en `spawn_window`, `window:set_position`) pero **no puede leerla** — `get_dimensions()` devuelve `pixel_width`, `pixel_height`, `dpi`, `is_full_screen` y nada más. No hay x/y en ninguna parte de la API Lua, así que "recordar dónde la dejé" es **imposible en Lua puro**.

**La solución:** que la lea Windows. `gui-startup` levanta un vigía que consulta `GetWindowPlacement` cada 2 s y anota la posición en `~/.wezterm-position.txt`; al arrancar, la config la restaura. La clave es `rcNormalPosition` (ver §6).

Decisiones que costaron y no se deducen del código:

- **Vigía compilado, no PowerShell.** La 1ª versión era un `.ps1` residente: **78 MB** de RAM. El mismo bucle en C# compilado con el `csc.exe` que ya trae .NET Framework 4 (de fábrica en Win10/11) pesa **5,6 KB** y usa **16 MB**. Se compila **solo**, la primera vez que abrís, así que no hay paso de instalación y `wezterm.lua` sigue siendo **el único archivo a desplegar**.
- **`/target:winexe` es lo que evita la ventana negra.** `powershell.exe` y `csc.exe` son apps de consola: lanzadas desde `wezterm-gui` (que no tiene consola) Windows les abre una. Por eso la compilación —única vez— pasa por `wscript.exe //B` (subsistema GUI) con `Run …, 0, False` = oculto. El ejecutable ya compilado se lanza directo: siendo winexe no abre nada.
- **Hay que darle tiempo a que la ventana exista.** En `gui-startup` la ventana todavía no tiene `MainWindowHandle`, así que un vigía que salga al primer "no la encuentro" se muere sin hacer nada. Tolera 30 fallos al inicio; recién **después** de haberla visto, 3 fallos seguidos = cerraron WezTerm y se apaga solo.
- **Mutex con espera de 3 s, no `WaitOne(0)`.** Si cerrás y reabrís rápido, el vigía viejo sigue vivo unos segundos; rindiéndose de una nos quedábamos sin ninguno. Trampa de diagnóstico: un vigía anterior tomando el mutex hace que el nuevo salga en silencio — **parece un bug y es el comportamiento correcto**.
- **Solo Windows.** Todo el mecanismo está detrás de `IS_WINDOWS` (`wezterm.target_triple`). En Linux/macOS no se activa ni se fuerza posición: ahí ubicar la ventana es tarea del gestor de ventanas.
