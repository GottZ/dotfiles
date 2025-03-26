local wezterm = require 'wezterm'
local act = wezterm.action

local config = wezterm.config_builder()

-- config.window_background_opacity = 0.96

config.font = wezterm.font('Pragmasevka Nerd Font')
-- config.color_scheme = 'zenwritten_dark'
config.ssh_backend = "Ssh2"

config.force_reverse_video_cursor = true
config.colors = {
  foreground = "#c5c9c5",
  background = "#181616",
  cursor_bg = "#C8C093",
  cursor_fg = "#C8C093",
  cursor_border = "#C8C093",
  selection_fg = "#C8C093",
  selection_bg = "#2D4F67",
  scrollbar_thumb = "#16161D",
  split = "#16161D",
  ansi = {
    "#0D0C0C",
    "#C4746E",
    "#8A9A7B",
    "#C4B28A",
    "#8BA4B0",
    "#A292A3",
    "#8EA4A2",
    "#C8C093",
  },
  brights = {
    "#A6A69C",
    "#E46876",
    "#87A987",
    "#E6C384",
    "#7FB4CA",
    "#938AA9",
    "#7AA89F",
    "#C5C9C5",
  },
}

config.use_fancy_tab_bar = false

config.colors.tab_bar = {
  inactive_tab_edge = config.colors.split,
  background = config.colors.background,
  active_tab = {
    fg_color = config.colors.foreground,
    bg_color = config.colors.background,
    -- underline = "Single",
    underline = "None",
    italic = false,
    intensity = "Bold",
  },
  inactive_tab = {
    fg_color = config.colors.cursor_fg,
    bg_color = config.colors.background,
    underline = "None",
    italic = true,
    intensity = "Normal",
  },
}
config.colors.tab_bar.new_tab = config.colors.tab_bar.inactive_tab

-- config.colors.compose_cursor = "orange"



config.keys = {
  --{ key = "Insert", mods = "SHIFT", action = act.PasteFrom("PrimarySelection") }
  { key = "Insert", mods = "SHIFT", action = act.PasteFrom("Clipboard") }
}

if wezterm.target_triple == 'x86_64-pc-windows-msvc' then
  local launch_menu = {}

  table.insert(launch_menu, {
    label = 'PowerShell 7',
    args = { 'pwsh.exe', '-NoLogo' },
  })

  table.insert(launch_menu, {
    label = 'PowerShell 6',
    args = { 'powershell.exe', '-NoLogo' },
  })

  table.insert(launch_menu, {
    label = 'cmd',
    args = { 'cmd.exe', '-NoLogo' },
  })

  -- Find installed visual studio version(s) and add their compilation
  -- environment command prompts to the menu
  for _, vsvers in
    ipairs(
      wezterm.glob('Microsoft Visual Studio/20*', 'C:/Program Files (x86)')
    )
  do
    local year = vsvers:gsub('Microsoft Visual Studio/', '')
    table.insert(launch_menu, {
      label = 'x64 Native Tools VS ' .. year,
      args = {
        'cmd.exe',
        '/k',
        'C:/Program Files (x86)/'
          .. vsvers
          .. '/BuildTools/VC/Auxiliary/Build/vcvars64.bat',
      },
    })
  end

  config.launch_menu = launch_menu
  config.default_prog = launch_menu[1].args

else
  -- set selected cursor theme on linux
  local success, stdout, stderr = wezterm.run_child_process{
    "gsettings", "get", "org.gnome.desktop.interface", "cursor-theme"
  }
  if success then
    config.xcursor_theme = stdout:gsub("'(.+)'\n", "%1")
  end

  -- set selected cursor size on linux
  local success, stdout, stderr = wezterm.run_child_process{
    "gsettings", "get", "org.gnome.desktop.interface", "cursor-size"
  }
  if success then
    config.xcursor_size = tonumber(stdout)
  end
end

return config
