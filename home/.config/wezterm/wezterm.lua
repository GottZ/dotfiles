local wezterm = require 'wezterm'
local act = wezterm.action

local config = wezterm.config_builder()

config.font = wezterm.font('Pragmasevka Nerd Font')
--config.color_scheme = 'rose-pine'
config.color_scheme = 'zenwritten_dark'
--config.color_scheme = 'ayu'
config.ssh_backend = "Ssh2"

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
end

return config
