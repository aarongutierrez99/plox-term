local wezterm = require("wezterm")
local config = wezterm.config_builder()

-- =====================================================================
--  TEMAS — cambio en vivo estilo Termius
--    Ctrl+Shift+Space  → selector de temas (lista buscable)
--    F12               → ciclar al siguiente tema
--  El tema elegido se guarda y se recuerda al reabrir.
--  Para AGREGAR un tema: copiá un bloque, cambiá colores, sumalo a `order`.
--  Estructura ansi/brights = { black, red, green, yellow, blue, magenta, cyan, white }
-- =====================================================================
local themes = {
  ["Tokyo Night"] = {   -- premium azul (senior)
    fg = "#C0CAF5", bg = "#16161E", cursor = "#7DCFFF", sel = "#283457",
    ansi    = { "#15161E", "#F7768E", "#9ECE6A", "#E0AF68", "#7AA2F7", "#BB9AF7", "#7DCFFF", "#A9B1D6" },
    brights = { "#414868", "#F7768E", "#9ECE6A", "#E0AF68", "#7AA2F7", "#BB9AF7", "#7DCFFF", "#C0CAF5" },
    tab = "#7DCFFF", tabbg = "#1F2335", tab_off = "#565F89", opacity = 1.0,
  },
  ["Hacker Green"] = {  -- verde fósforo, negro-verde translúcido
    fg = "#3FF58F", bg = "#060A08", cursor = "#6EFFB0", sel = "#12331F",
    ansi    = { "#0A0F0C", "#FF5F6A", "#3FF58F", "#C8E650", "#2DD4BF", "#7FFFD4", "#00FFCC", "#A8F5C8" },
    brights = { "#2A5F3F", "#FF7A85", "#6EFFB0", "#DCEB7A", "#5EEAD4", "#A0FFE0", "#4DFFDA", "#D0FFE4" },
    tab = "#6EFFB0", tabbg = "#0D1A12", tab_off = "#2A5F3F", opacity = 0.82,
  },
  ["Matrix Black"] = {  -- verde sobre negro PURO, translúcido
    fg = "#33FF66", bg = "#000000", cursor = "#66FF99", sel = "#0D2A15",
    ansi    = { "#0A0A0A", "#FF4444", "#33FF66", "#AEFF4D", "#2DE0A6", "#6EFFC0", "#4DFFD4", "#9BFFB0" },
    brights = { "#1A3320", "#FF6B6B", "#66FF99", "#CFFF6B", "#5EEAC8", "#A0FFDA", "#7DFFE4", "#C4FFD0" },
    tab = "#66FF99", tabbg = "#0A1A0F", tab_off = "#2A6B3F", opacity = 0.82,
  },
  ["Neon Cyber"] = {    -- cyan neón cyberpunk, translúcido
    fg = "#9FEFFF", bg = "#04080D", cursor = "#00F0FF", sel = "#0E3A47",
    ansi    = { "#0A1520", "#FF5370", "#4DFFB8", "#FFE66D", "#38BDF8", "#C792EA", "#00F0FF", "#A9D9E8" },
    brights = { "#1E3A4A", "#FF7A9C", "#7DFFCE", "#FFF0A0", "#6DD3FF", "#DDA9F0", "#6FFFFF", "#D0F5FF" },
    tab = "#00F0FF", tabbg = "#0A2530", tab_off = "#3A6472", opacity = 0.85,
  },
  ["Synthwave 84"] = {  -- retro neón magenta+cyan, translúcido
    fg = "#E8E4F0", bg = "#1B1130", cursor = "#FF7EDB", sel = "#2D2140",
    ansi    = { "#2A2139", "#FE4450", "#72F1B8", "#FEDE5D", "#03EDF9", "#FF7EDB", "#36F9F6", "#B6B1C4" },
    brights = { "#495495", "#FE4450", "#72F1B8", "#FEDE5D", "#36F9F6", "#FF7EDB", "#36F9F6", "#E8E4F0" },
    tab = "#FF7EDB", tabbg = "#2D2140", tab_off = "#6E5E86", opacity = 0.86,
  },
  ["Blood Dragon"] = {  -- neón rojo/naranja sobre negro, translúcido
    fg = "#F8E3E0", bg = "#0A0204", cursor = "#FF3355", sel = "#3A0E14",
    ansi    = { "#1A0A0C", "#FF3355", "#C6FF00", "#FF9E3B", "#22D3EE", "#FF2E97", "#22D3EE", "#E8C4C0" },
    brights = { "#4A1A20", "#FF5C7A", "#DAFF4D", "#FFB55E", "#4DE0F0", "#FF5CAE", "#4DE0F0", "#FFE0DC" },
    tab = "#FF3355", tabbg = "#2A0E14", tab_off = "#7A3A42", opacity = 0.84,
  },
  ["Dracula"] = {       -- icónico púrpura/rosa
    fg = "#F8F8F2", bg = "#282A36", cursor = "#BD93F9", sel = "#44475A",
    ansi    = { "#21222C", "#FF5555", "#50FA7B", "#F1FA8C", "#BD93F9", "#FF79C6", "#8BE9FD", "#F8F8F2" },
    brights = { "#6272A4", "#FF6E6E", "#69FF94", "#FFFFA5", "#D6ACFF", "#FF92DF", "#A4FFFF", "#FFFFFF" },
    tab = "#BD93F9", tabbg = "#343746", tab_off = "#6272A4", opacity = 1.0,
  },
  ["Rose Pine"] = {     -- elegante, rosa/oro/pino apagados
    fg = "#E0DEF4", bg = "#191724", cursor = "#E0DEF4", sel = "#403D52",
    ansi    = { "#26233A", "#EB6F92", "#31748F", "#F6C177", "#9CCFD8", "#C4A7E7", "#EBBCBA", "#E0DEF4" },
    brights = { "#6E6A86", "#EB6F92", "#31748F", "#F6C177", "#9CCFD8", "#C4A7E7", "#EBBCBA", "#E0DEF4" },
    tab = "#C4A7E7", tabbg = "#26233A", tab_off = "#6E6A86", opacity = 1.0,
  },
  ["Kanagawa Wave"] = { -- tinta japonesa, sofisticado
    fg = "#DCD7BA", bg = "#1F1F28", cursor = "#C8C093", sel = "#2D4F67",
    ansi    = { "#090618", "#C34043", "#76946A", "#C0A36E", "#7E9CD8", "#957FB8", "#6A9589", "#C8C093" },
    brights = { "#727169", "#E82424", "#98BB6C", "#E6C384", "#7FB4CA", "#938AA9", "#7AA89F", "#DCD7BA" },
    tab = "#7E9CD8", tabbg = "#2A2A37", tab_off = "#727169", opacity = 1.0,
  },
  ["Everforest"] = {    -- verde cálido, descansado
    fg = "#D3C6AA", bg = "#2D353B", cursor = "#A7C080", sel = "#475258",
    ansi    = { "#4B565C", "#E67E80", "#A7C080", "#DBBC7F", "#7FBBB3", "#D699B6", "#83C092", "#D3C6AA" },
    brights = { "#4B565C", "#E67E80", "#A7C080", "#DBBC7F", "#7FBBB3", "#D699B6", "#83C092", "#9DA9A0" },
    tab = "#A7C080", tabbg = "#3D484D", tab_off = "#859289", opacity = 1.0,
  },
  ["Monokai Pro"] = {   -- vibrante clásico
    fg = "#FCFCFA", bg = "#2D2A2E", cursor = "#FFD866", sel = "#5B595C",
    ansi    = { "#403E41", "#FF6188", "#A9DC76", "#FFD866", "#FC9867", "#AB9DF2", "#78DCE8", "#FCFCFA" },
    brights = { "#727072", "#FF6188", "#A9DC76", "#FFD866", "#FC9867", "#AB9DF2", "#78DCE8", "#FCFCFA" },
    tab = "#78DCE8", tabbg = "#403E41", tab_off = "#727072", opacity = 1.0,
  },
  ["Ayu Mirage"] = {    -- moderno, naranja/azul cálido
    fg = "#CBCCC6", bg = "#1F2430", cursor = "#FFCC66", sel = "#33415E",
    ansi    = { "#1A1F29", "#F28779", "#BAE67E", "#FFD580", "#73D0FF", "#D4BFFF", "#95E6CB", "#C7C7C7" },
    brights = { "#686868", "#F28779", "#BAE67E", "#FFD580", "#73D0FF", "#D4BFFF", "#95E6CB", "#FFFFFF" },
    tab = "#73D0FF", tabbg = "#2A3444", tab_off = "#607080", opacity = 1.0,
  },
  ["Catppuccin Mocha"] = {  -- pastel cálido premium
    fg = "#CDD6F4", bg = "#1E1E2E", cursor = "#F5E0DC", sel = "#45475A",
    ansi    = { "#45475A", "#F38BA8", "#A6E3A1", "#F9E2AF", "#89B4FA", "#F5C2E7", "#94E2D5", "#BAC2DE" },
    brights = { "#585B70", "#F38BA8", "#A6E3A1", "#F9E2AF", "#89B4FA", "#F5C2E7", "#94E2D5", "#A6ADC8" },
    tab = "#89B4FA", tabbg = "#313244", tab_off = "#6C7086", opacity = 1.0,
  },
  ["Nord"] = {  -- frío sobrio
    fg = "#D8DEE9", bg = "#2E3440", cursor = "#88C0D0", sel = "#434C5E",
    ansi    = { "#3B4252", "#BF616A", "#A3BE8C", "#EBCB8B", "#81A1C1", "#B48EAD", "#88C0D0", "#E5E9F0" },
    brights = { "#4C566A", "#BF616A", "#A3BE8C", "#EBCB8B", "#81A1C1", "#B48EAD", "#8FBCBB", "#ECEFF4" },
    tab = "#88C0D0", tabbg = "#3B4252", tab_off = "#6C7A96", opacity = 0.94,
  },
  ["Gruvbox"] = {  -- retro cálido
    fg = "#EBDBB2", bg = "#1D2021", cursor = "#FABD2F", sel = "#504945",
    ansi    = { "#282828", "#CC241D", "#98971A", "#D79921", "#458588", "#B16286", "#689D6A", "#A89984" },
    brights = { "#928374", "#FB4934", "#B8BB26", "#FABD2F", "#83A598", "#D3869B", "#8EC07C", "#EBDBB2" },
    tab = "#FABD2F", tabbg = "#3C3836", tab_off = "#7C6F64", opacity = 1.0,
  },
}
local order = {
  "Tokyo Night", "Hacker Green", "Matrix Black", "Neon Cyber", "Synthwave 84",
  "Blood Dragon", "Dracula", "Rose Pine", "Kanagawa Wave", "Everforest",
  "Monokai Pro", "Ayu Mirage", "Catppuccin Mocha", "Nord", "Gruvbox",
}

local THEME_FILE = wezterm.home_dir .. "/.wezterm-theme.txt"

local function read_active()
  local ok, f = pcall(io.open, THEME_FILE, "r")
  if ok and f then
    local n = f:read("*l"); f:close()
    if n and themes[n] then return n end
  end
  return "Tokyo Night"
end

local function write_active(name)
  local ok, f = pcall(io.open, THEME_FILE, "w")
  if ok and f then f:write(name); f:close() end
end

local function colors_for(t)
  return {
    foreground = t.fg,
    background = t.bg,
    cursor_bg = t.cursor,
    cursor_fg = t.bg,
    cursor_border = t.cursor,
    selection_bg = t.sel,
    selection_fg = t.fg,
    scrollbar_thumb = t.tabbg,
    split = t.tabbg,
    ansi = t.ansi,
    brights = t.brights,
    tab_bar = {
      background = t.bg,
      active_tab         = { bg_color = t.tabbg,  fg_color = t.tab,     intensity = "Bold" },
      inactive_tab       = { bg_color = t.bg,     fg_color = t.tab_off },
      inactive_tab_hover = { bg_color = t.tabbg,  fg_color = t.tab },
      new_tab            = { bg_color = t.bg,     fg_color = t.tab_off },
      new_tab_hover      = { bg_color = t.tabbg,  fg_color = t.tab },
    },
  }
end

-- window_frame por tema: fuente de la barra + BORDE del color de acento del tema
-- en los 4 lados (WezTerm no hace glow real; el brillo lo da el color de acento).
local function frame_for(t)
  return {
    font = wezterm.font("JetBrainsMono Nerd Font", { weight = "Medium" }),
    font_size = 9,   -- proporcional al cuerpo para que la barra no quede más grande
    active_titlebar_bg   = t.bg,
    inactive_titlebar_bg = t.bg,
    -- Marco apagado. Para volver a tener borde neón, subí estos a "0.2cell" /
    -- "0.1cell" y agregá border_*_color = t.tab.
    border_left_width    = 0,
    border_right_width   = 0,
    border_top_height    = 0,
    border_bottom_height = 0,
  }
end

local function apply_theme(window, name)
  local t = themes[name]
  window:set_config_overrides({
    colors = colors_for(t),
    window_background_opacity = t.opacity,
    window_frame = frame_for(t),
  })
  write_active(name)
  window:toast_notification("WezTerm", "Tema · " .. name, nil, 1500)
end

-- Tema activo al arrancar
local active = read_active()
config.colors = colors_for(themes[active])
config.window_background_opacity = themes[active].opacity

--------------------------------------------------
-- Rendimiento
--------------------------------------------------
config.front_end = "WebGpu"
config.max_fps = 144
config.animation_fps = 144

--------------------------------------------------
-- Fuente
--------------------------------------------------
config.font = wezterm.font("JetBrainsMono Nerd Font")
config.font_size = 10   -- tamaño de naturaleza (equivale a ~2× Ctrl+- sobre 11.5)
config.line_height = 1.15
config.cell_width = 1.0
config.harfbuzz_features = { "calt=1", "clig=1", "liga=1" }

--------------------------------------------------
-- Ventana
--------------------------------------------------
config.text_background_opacity = 1.0
config.window_padding = { left = 12, right = 12, top = 8, bottom = 6 }
config.window_decorations = "INTEGRATED_BUTTONS|RESIZE"
config.integrated_title_button_style = "Windows"
config.inactive_pane_hsb = { saturation = 0.9, brightness = 0.72 }
-- initial_cols / initial_rows los fija la sección "Geometría" de abajo.

--------------------------------------------------
-- Geometría · tamaño FIJO, posición RECORDADA
--------------------------------------------------
-- TAMAÑO: fijo a propósito. Guardar "el último tamaño" suena mejor pero se rompe
-- con el maximizado: quedaría guardada la medida maximizada y la próxima ventana,
-- que nace flotante, se pasaría de la pantalla. WezTerm no expone "¿estoy
-- maximizado?" (get_dimensions solo trae is_full_screen), así que no hay forma de
-- filtrarlo. Con la medida clavada, maximizar sale gratis: al reabrir volvés
-- siempre a esta. Para cambiarla: redimensioná a gusto y leé los valores con
--   wezterm.exe cli list --format json     (campo "size": cols / rows)
-- >>> Si clonaste este repo: ESTE es el valor a tocar. Está medido para un monitor
-- >>> 1080p; en una pantalla más chica bajalo o la ventana va a nacer pasada.
local WIN_COLS, WIN_ROWS = 174, 39
config.initial_cols = WIN_COLS
config.initial_rows = WIN_ROWS

-- POSICIÓN: WezTerm puede ESCRIBIRLA (`position` en spawn_window,
-- `window:set_position`) pero NO puede leerla — no hay x/y en ninguna parte de la
-- API Lua. Así que la lee Windows: un vigía en segundo plano consulta
-- GetWindowPlacement y deja la posición en POS_FILE; acá solo se restaura.
--
-- La clave es usar `rcNormalPosition` y NO GetWindowRect: es la posición
-- RESTAURADA, que sigue siendo la correcta aunque la ventana esté maximizada o
-- minimizada. Por eso el maximizado tampoco ensucia la posición guardada.
-- Todo este mecanismo es de Windows. En Linux/macOS no se activa: no hay a quién
-- preguntarle la posición, y ahí ubicar la ventana es tarea del gestor de ventanas.
local IS_WINDOWS   = (wezterm.target_triple or ""):find("windows") ~= nil
local POS_FILE     = wezterm.home_dir .. "\\.wezterm-position.txt"
local WATCH_CS     = wezterm.home_dir .. "\\.wezterm-pos-watch.cs"
local WATCH_EXE    = wezterm.home_dir .. "\\.wezterm-pos-watch.exe"
local WATCH_VER_F  = wezterm.home_dir .. "\\.wezterm-pos-watch.ver"
local WATCH_VBS    = wezterm.home_dir .. "\\.wezterm-pos-watch.vbs"
local WATCH_VER    = "1"                    -- subir esto obliga a recompilar el vigía
local POS_FALLBACK = { x = 251, y = 101 }   -- mientras no haya nada guardado

local function read_line(path)
  local ok, f = pcall(io.open, path, "r")
  if ok and f then local l = f:read("*l"); f:close(); return l end
  return nil
end

local function file_exists(path)
  local ok, f = pcall(io.open, path, "r")
  if ok and f then f:close(); return true end
  return false
end

local function write_file(path, body)
  local ok, f = pcall(io.open, path, "w")
  if ok and f then f:write(body); f:close(); return true end
  return false
end

local function read_pos()
  local line = read_line(POS_FILE)
  if line then
    local x, y = line:match("^(-?%d+)%s+(-?%d+)$")
    x, y = tonumber(x), tonumber(y)
    -- Cordura: descarta el -32000 de ventana minimizada y cualquier disparate.
    if x and y and x > -30000 and y > -30000 and x < 30000 and y < 30000 then
      return { x = x, y = y }
    end
  end
  return POS_FALLBACK
end

-- El vigía se genera y se compila solo la primera vez, así que wezterm.lua sigue
-- siendo el ÚNICO archivo que hay que desplegar. Es un ejecutable de ~5 KB en vez
-- de un PowerShell residente: 16 MB de RAM contra 78 MB, medidos. Y compilado como
-- /target:winexe no abre ninguna ventana de consola.
-- Lleva BOM UTF-8 para que csc.exe no rompa los acentos de los comentarios.
local WATCH_CS_BODY = "\239\187\191" .. [==[
// plox-term · vigía de la posición de la ventana de WezTerm.
// Lo genera wezterm.lua: NO editar acá, se pisa en cada arranque.
using System;
using System.Diagnostics;
using System.IO;
using System.Runtime.InteropServices;
using System.Threading;

static class PosWatch {
    [StructLayout(LayoutKind.Sequential)] struct RECT { public int Left, Top, Right, Bottom; }
    [StructLayout(LayoutKind.Sequential)] struct POINT { public int X, Y; }
    [StructLayout(LayoutKind.Sequential)] struct WINDOWPLACEMENT {
        public int length, flags, showCmd;
        public POINT ptMinPosition, ptMaxPosition;
        public RECT rcNormalPosition;
    }
    [DllImport("user32.dll")] static extern bool GetWindowPlacement(IntPtr hWnd, ref WINDOWPLACEMENT p);

    static IntPtr FindWezWindow() {
        foreach (Process p in Process.GetProcessesByName("wezterm-gui"))
            if (p.MainWindowHandle != IntPtr.Zero) return p.MainWindowHandle;
        return IntPtr.Zero;
    }

    static int Main() {
        // Un solo vigía aunque se abran varias ventanas. Espera 3s en vez de
        // rendirse de una: si cerrás y reabrís rápido, el vigía viejo puede seguir
        // vivo unos segundos y sin esta espera nos quedaríamos sin ninguno.
        using (Mutex mutex = new Mutex(false, "ploxterm-pos-watch")) {
            bool have;
            try { have = mutex.WaitOne(3000); }
            catch (AbandonedMutexException) { have = true; }  // el anterior murió sin soltarlo
            if (!have) return 0;
            try {
                string outPath = Path.Combine(
                    Environment.GetFolderPath(Environment.SpecialFolder.UserProfile),
                    ".wezterm-position.txt");
                string last = "";
                bool seen = false;
                int misses = 0;
                while (true) {
                    IntPtr h = FindWezWindow();
                    if (h == IntPtr.Zero) {
                        misses++;
                        // Al arrancar, la ventana todavía no existe: hay que darle
                        // tiempo. Si YA se vio y desaparece, es que cerraron WezTerm.
                        if (seen && misses >= 3) break;
                        if (!seen && misses > 30) break;
                    } else {
                        seen = true; misses = 0;
                        WINDOWPLACEMENT wp = new WINDOWPLACEMENT();
                        wp.length = Marshal.SizeOf(wp);
                        // rcNormalPosition = posición RESTAURADA: sigue siendo la
                        // correcta con la ventana maximizada o minimizada. Con
                        // GetWindowRect se guardaría -8,-8 al maximizar.
                        if (GetWindowPlacement(h, ref wp)) {
                            int x = wp.rcNormalPosition.Left, y = wp.rcNormalPosition.Top;
                            string v = x + " " + y;
                            // Reescribe también si borraron el archivo.
                            if ((v != last || !File.Exists(outPath)) && x > -30000 && y > -30000) {
                                try { File.WriteAllText(outPath, v); last = v; } catch { }
                            }
                        }
                    }
                    Thread.Sleep(2000);
                }
            } finally { mutex.ReleaseMutex(); }
        }
        return 0;
    }
}
]==]

-- Solo se usa la PRIMERA vez (o al subir WATCH_VER): compila el vigía y lo arranca.
-- csc.exe es una app de consola, así que se lo llama desde wscript.exe —del
-- subsistema GUI— con estilo 0 = oculto: no parpadea ninguna ventana negra.
-- csc.exe viene con .NET Framework 4, de fábrica en Windows 10 y 11.
-- (Comentarios sin acentos: wscript lee el .vbs como ANSI.)
local WATCH_VBS_BODY = [==[
' plox-term · compila el vigia de posicion y lo lanza, sin ventana de consola.
' Lo genera wezterm.lua: NO editar aca, se pisa.
Set sh  = CreateObject("WScript.Shell")
Set fso = CreateObject("Scripting.FileSystemObject")
home = sh.ExpandEnvironmentStrings("%USERPROFILE%")
win  = sh.ExpandEnvironmentStrings("%SystemRoot%")
exe  = home & "\.wezterm-pos-watch.exe"
src  = home & "\.wezterm-pos-watch.cs"
csc  = win & "\Microsoft.NET\Framework64\v4.0.30319\csc.exe"
If Not fso.FileExists(csc) Then csc = win & "\Microsoft.NET\Framework\v4.0.30319\csc.exe"
If (Not fso.FileExists(exe)) And fso.FileExists(csc) Then
  sh.Run """" & csc & """ /nologo /target:winexe /optimize+ /out:""" & exe & """ """ & src & """", 0, True
End If
If fso.FileExists(exe) Then sh.Run """" & exe & """", 0, False
]==]

wezterm.on("gui-startup", function(cmd)
  -- `cmd` trae lo pedido por línea de comandos (o nil). Se copia para no pisarle
  -- nada y se le agrega la geometría.
  if cmd ~= nil and type(cmd) ~= "table" then
    wezterm.mux.spawn_window(cmd)   -- caso raro: que pase tal cual antes que romper
  else
    local args = {}
    if cmd then for k, v in pairs(cmd) do args[k] = v end end
    args.width, args.height = WIN_COLS, WIN_ROWS
    -- Fuera de Windows no hay quién lea la posición, así que no se fuerza ninguna:
    -- la ubica el gestor de ventanas, que es lo esperable ahí.
    if IS_WINDOWS then
      local pos = read_pos()
      args.position = { x = pos.x, y = pos.y }
    end
    wezterm.mux.spawn_window(args)
  end

  -- Levantar el vigía (solo Windows). Se apaga solo al cerrarse WezTerm.
  if IS_WINDOWS then
    write_file(WATCH_CS, WATCH_CS_BODY)
    -- Si cambió la versión del vigía, tirar el .exe viejo para que se recompile.
    if read_line(WATCH_VER_F) ~= WATCH_VER then
      os.remove(WATCH_EXE)
      write_file(WATCH_VER_F, WATCH_VER)
    end
    if file_exists(WATCH_EXE) then
      pcall(wezterm.background_child_process, { WATCH_EXE })
    elseif write_file(WATCH_VBS, WATCH_VBS_BODY) then
      -- Primera vez: compilar (oculto) y arrancar.
      pcall(wezterm.background_child_process, { "wscript.exe", "//B", "//Nologo", WATCH_VBS })
    end
  end
end)

--------------------------------------------------
-- Tabs
--------------------------------------------------
config.enable_tab_bar = true
config.use_fancy_tab_bar = true
config.hide_tab_bar_if_only_one_tab = false
config.tab_max_width = 28
config.show_tab_index_in_tab_bar = false
config.switch_to_last_active_tab_when_closing_tab = true
config.window_frame = frame_for(themes[active])

wezterm.on("format-tab-title", function(tab, tabs, panes, cfg, hover, max_width)
  local i = tab.tab_index + 1
  local title = tab.active_pane.title or ""
  title = title:gsub("^Copy mode: ", "")
  local cap = 22
  if #title > cap then title = title:sub(1, cap - 1) .. "…" end
  return string.format("  %d · %s  ", i, title)
end)

--------------------------------------------------
-- Cursor
--------------------------------------------------
config.default_cursor_style = "BlinkingBar"
config.cursor_blink_rate = 800
config.cursor_blink_ease_in = "EaseOut"
config.cursor_blink_ease_out = "EaseOut"
config.audible_bell = "Disabled"

--------------------------------------------------
-- Scroll
--------------------------------------------------
config.enable_scroll_bar = false
config.scrollback_lines = 50000

--------------------------------------------------
-- WSL
--------------------------------------------------
config.default_prog = { "wsl.exe", "--cd", "~" }

--------------------------------------------------
-- Atajos
--------------------------------------------------
config.keys = {
  { key = "Enter", mods = "ALT", action = wezterm.action.ToggleFullScreen },

  -- Selector de temas (Termius-like)
  {
    key = "Space", mods = "CTRL|SHIFT",
    action = wezterm.action_callback(function(window, pane)
      local choices = {}
      for _, n in ipairs(order) do choices[#choices + 1] = { label = n } end
      window:perform_action(
        wezterm.action.InputSelector({
          title = "Elegí un tema  ·  ↑↓ o escribí para filtrar  ·  Enter",
          choices = choices,
          action = wezterm.action_callback(function(win, p, id, label)
            if label then apply_theme(win, label) end
          end),
        }),
        pane
      )
    end),
  },

  -- Ciclar al siguiente tema
  {
    key = "F12",
    action = wezterm.action_callback(function(window, pane)
      local cur = read_active()
      local idx = 1
      for i, n in ipairs(order) do if n == cur then idx = i break end end
      apply_theme(window, order[(idx % #order) + 1])
    end),
  },

  -- Splits. Inyectan PLOX_NOGREET=1 para que el banner NO se repita en el pane
  -- nuevo (ventana/pestaña nueva sí saludan; el split queda limpio).
  --   Ctrl+Shift+|  → pane a la derecha (| = divisor vertical)
  --   Ctrl+Shift+_  → pane abajo       (_ = divisor horizontal)
  {
    key = "|", mods = "CTRL|SHIFT",
    action = wezterm.action.SplitHorizontal({
      set_environment_variables = { PLOX_NOGREET = "1" },
    }),
  },
  {
    key = "_", mods = "CTRL|SHIFT",
    action = wezterm.action.SplitVertical({
      set_environment_variables = { PLOX_NOGREET = "1" },
    }),
  },
}

return config
