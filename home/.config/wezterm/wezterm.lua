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

return config
