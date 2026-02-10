local wezterm = require 'wezterm'
local act = wezterm.action

local config = wezterm.config_builder()

config.enable_kitty_keyboard = true
config.enable_csi_u_key_encoding = false

-- config.window_background_opacity = 0.96

config.font = wezterm.font('Pragmasevka Nerd Font')
-- config.color_scheme = 'zenwritten_dark'
config.ssh_backend = "Ssh2"

-- config.force_reverse_video_cursor = true
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



if wezterm.target_triple == 'x86_64-pc-windows-msvc' then
  -- config.ssh_backend = "LibSsh"
  local ok, stdout, _ = wezterm.run_child_process { 'sc.exe', 'query', 'ssh-agent' }
  if ok and stdout:find('RUNNING') then
    local pipe = "\\\\.\\pipe\\openssh-ssh-agent"
    pcall(function()
      config.default_ssh_auth_sock = pipe
    end)
    config.set_environment_variables = {
      SSH_AUTH_SOCK = pipe,
    }
  end
end

config.ssh_domains = {}
for host, ssh_config in pairs(wezterm.enumerate_ssh_hosts()) do
  if host ~= '*' then
    local address = (ssh_config.hostname or host) .. (ssh_config.port and (":" .. ssh_config.port) or "")
    local user = ssh_config.user or "root"
    table.insert(config.ssh_domains, {
      name = host,
      remote_address = address,
      username = user,
      multiplexing = "None",
    })
    table.insert(config.ssh_domains, {
      name = "mux-" .. host,
      remote_address = address,
      username = user,
    })
  end
end

config.keys = {
  --{ key = "Insert", mods = "SHIFT", action = act.PasteFrom("PrimarySelection") }
  { key = "Insert", mods = "SHIFT", action = act.PasteFrom("Clipboard") }
}

-- in part thanks to https://github.com/wezterm/wezterm/issues/5963#issuecomment-2533250740
if wezterm.target_triple == 'x86_64-pc-windows-msvc' then
  local launch_menu = {}

  local function is_executable_in_path(executable)
    return wezterm.run_child_process { 'where.exe', '/Q', executable }
  end

  local set_default_prog = function()
    if config.default_prog then
      return
    end

    if #launch_menu > 0 then
      config.default_prog = launch_menu[1].args
    end
  end

  local pwsh = is_executable_in_path 'pwsh.exe'
  local powershell = is_executable_in_path 'powershell.exe'
  local git = is_executable_in_path 'git.exe'
  local elvish = is_executable_in_path 'elvish.exe'
  local nu = is_executable_in_path 'nu.exe'

  -- Use powershell to query the registry for the Git for Windows install path
  local bash_path = ''
  if git and ( pwsh or powershell ) then
    local shell = pwsh and 'pwsh.exe' or 'powershell.exe'
    local git_registry, git_path, _ = wezterm.run_child_process {
      shell,
      '-Command',
      [[(Get-ItemProperty -Path Registry::HKEY_LOCAL_MACHINE\SOFTWARE\GitForWindows).InstallPath]],
    }
    if git_registry then
      for _, line in ipairs(wezterm.split_by_newlines(git_path)) do
        bash_path = bash_path .. line
      end
      bash_path = bash_path .. [[\bin\bash.exe]]
    end
  end

  if pwsh then
    table.insert(launch_menu, {
      label = 'PowerShell 7',
      args = { 'pwsh.exe', '-NoLogo' },
    })
    set_default_prog()
  end

  if powershell then
    table.insert(launch_menu, {
      label = 'PowerShell 6',
      args = { 'powershell.exe', '-NoLogo' },
    })
    set_default_prog()
  end

  table.insert(launch_menu, {
    label = 'cmd',
    args = { os.getenv 'COMSPEC', '/k' },
  })
  set_default_prog()

  if git and bash_path ~= '' then
    table.insert(launch_menu, {
      label = 'Git Bash',
      args = { bash_path, '-i', '-l' },
    })
  end

  if elvish then
    table.insert(launch_menu, {
      label = 'Elvish',
      args = { 'elvish.exe' },
    })
  end

  if nu then
    table.insert(launch_menu, {
      label = 'NuShell',
      args = { 'nu.exe' },
    })
  end

  -- Add WSL to the launch menu if it is available
  --local wsl_available = wezterm.run_child_process { 'wsl.exe', '--list', '--quiet' }
  --if wsl_available then
  --  table.insert(launch_menu, {
  --    label = 'WSL',
  --    args = { 'wsl.exe', '-d', 'Ubuntu-20.04' }, -- Change to your preferred distro
  --  })
  --end

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

else
  -- set selected cursor theme on linux
  local success, stdout, _ = wezterm.run_child_process{
    "gsettings", "get", "org.gnome.desktop.interface", "cursor-theme"
  }
  if success then
    config.xcursor_theme = stdout:gsub("'(.+)'\n", "%1")
  end

  -- set selected cursor size on linux
  success, stdout, _ = wezterm.run_child_process{
    "gsettings", "get", "org.gnome.desktop.interface", "cursor-size"
  }
  if success then
    config.xcursor_size = tonumber(stdout)
  end
end

return config
