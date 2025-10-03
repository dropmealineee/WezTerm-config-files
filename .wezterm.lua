-- Pull in the wezterm API
local wezterm = require 'wezterm'
local act = wezterm.action

-- This will hold the configuration.
local config = wezterm.config_builder()

-- Base settings
config.window_background_opacity = 0.7
config.prefer_egl = true
config.font_size = 11.0
config.cell_width = 0.9
config.window_decorations = "NONE | RESIZE"
config.default_prog = { "powershell.exe", "-NoLogo" }

-- Geometry & position
config.initial_cols = 140
config.initial_rows = 28

-- Hide the tab bar if there is only one tab
config.hide_tab_bar_if_only_one_tab = true
config.use_fancy_tab_bar = false

-- Colors
config.color_scheme = 'One Half Black (Gogh)'

-- Cursor style
config.default_cursor_style = "BlinkingBlock"
config.cursor_blink_rate = 500 -- blink every 500ms

-- Start centered at 80% of screen
wezterm.on("gui-startup", function(cmd)
  local screen = wezterm.gui.screens().active
  local width = math.floor(screen.width * 0.8)
  local height = math.floor(screen.height * 0.8)
  local xpos = math.floor((screen.width - width) / 2)
  local ypos = math.floor((screen.height - height) / 2)

  local tab, pane, window = wezterm.mux.spawn_window(cmd or {})
  window:gui_window():set_position(xpos, ypos)
  window:gui_window():set_inner_size(width, height)
end)

-- Key bindings
config.keys = {
  -- Split Panes
  {key=",", mods="CTRL|ALT", action=act.SplitHorizontal{domain="CurrentPaneDomain"}},
  {key=".", mods="CTRL|ALT", action=act.SplitVertical{domain="CurrentPaneDomain"}},

  -- Navigate Panes
  {key="h", mods="CTRL|ALT", action=act.ActivatePaneDirection("Left")},
  {key="l", mods="CTRL|ALT", action=act.ActivatePaneDirection("Right")},
  {key="k", mods="CTRL|ALT", action=act.ActivatePaneDirection("Up")},
  {key="j", mods="CTRL|ALT", action=act.ActivatePaneDirection("Down")},

  -- Adjust Pane Size
  {key="LeftArrow", mods="CTRL|SHIFT", action=act.AdjustPaneSize{"Left", 3}},
  {key="RightArrow", mods="CTRL|SHIFT", action=act.AdjustPaneSize{"Right", 3}},
  {key="UpArrow", mods="CTRL|SHIFT", action=act.AdjustPaneSize{"Up", 1}},
  {key="DownArrow", mods="CTRL|SHIFT", action=act.AdjustPaneSize{"Down", 1}},

  -- Pane Selector
  {key="p", mods="CTRL|SHIFT", action=act.PaneSelect{alphabet="1234567890"}},

  -- Toggle Fullscreen
  {key="F11", mods="", action=act.ToggleFullScreen},

  -- Tabs
  {key="t", mods="CTRL|SHIFT", action=act.SpawnTab("DefaultDomain")},
  {key="q", mods="CTRL|SHIFT", action=act.CloseCurrentTab{confirm=true}},

  -- Clipboard (keyboard)
  {key="c", mods="CTRL|SHIFT", action=act.CopyTo("Clipboard")},
  {key="v", mods="CTRL|SHIFT", action=act.PasteFrom("Clipboard")},

  -- Start Window Drag
  {key="d", mods="CTRL|SHIFT", action=act.StartWindowDrag},
}

-- Mouse bindings
config.mouse_bindings = {
  -- Right-click paste
  {
    event={Down={streak=1, button="Right"}},
    mods="NONE",
    action=act.PasteFrom("Clipboard"),
  },
  -- Ctrl + Left drag = select and copy on release
  {
    event={Drag={streak=1, button="Left"}},
    mods="CTRL",
    action=act.ExtendSelectionToMouseCursor("Cell"),
  },
  {
    event={Up={streak=1, button="Left"}},
    mods="CTRL",
    action=act.CopyTo("ClipboardAndPrimarySelection"),
  },
}

-- Return configuration
return config
