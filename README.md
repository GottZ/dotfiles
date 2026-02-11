# GottZ Dotfiles

Configuration files, helper scripts and system settings for an **Arch Linux** workstation.
The repo lives in `/opt/dotfiles` and is managed as root — most files are meant to be symlinked into `/etc`, `/usr/local/bin`, `/usr/share` or `$HOME`.

---

## Quick start

```bash
sudo git clone https://github.com/gottz/dotfiles.git /opt/dotfiles

# symlink what you need, e.g.
ln -s /opt/dotfiles/etc/gitconfig              /etc/gitconfig
ln -s /opt/dotfiles/etc/DIR_COLORS             /etc/DIR_COLORS
ln -s /opt/dotfiles/etc/zsh/zshrc.local        /etc/zsh/zshrc.local
ln -sf /opt/dotfiles/etc/profile.d/*           /etc/profile.d/
ln -sf /opt/dotfiles/usr/local/bin/*           /usr/local/bin/
ln -sf /opt/dotfiles/home/.config/tmux         ~/.config/tmux
ln -sf /opt/dotfiles/home/.config/ghostty      ~/.config/ghostty
ln -sf /opt/dotfiles/home/.config/wezterm      ~/.config/wezterm
ln -sf /opt/dotfiles/home/.ssh/allowed_signers ~/.ssh/allowed_signers
```

---

## Repository layout

### `etc/` — system configuration

| Path | Purpose |
|------|---------|
| `gitconfig` | Global git identity, SSH-based commit/tag signing, `defaultBranch = root`, rebase-on-pull, `fetch.prune`, `zdiff3` conflict style, `autoStash`, histogram diff algorithm. |
| `DIR_COLORS` | Rich dircolors database for `ls --color` (based on default + custom extensions). |
| `zsh/zshrc.local` | Zsh config on top of grml-zsh-config — see [Zsh section](#zsh) below. |
| `ssh/sshd_config.d/99-gottz.conf` | Hardened sshd: 10 s login grace, 1 auth attempt, key-only (no passwords). |
| `sudoers.d/00_timeout` | Sets `passwd_timeout=0` — sudo never caches credentials. |
| `docker/__hetzner.daemon.json` | Docker daemon template for Hetzner nodes: IPv6, ip6tables, large address pools (`172.32–192.0.0/12`). |
| `pacman.d/hooks/remove_old_cache.hook` | Pacman hook: runs `paccache -rvk1` after every transaction to keep only the last cached version. |
| `modprobe.d/sound-powersave.conf` | Disables power-save for `snd_hda_intel` and `snd_usb_audio`. |
| `modprobe.d/usb-power.conf` | Disables USB autosuspend, sets `mousepoll=0` for lowest latency. |
| `systemd/system/kanata.service` | Systemd unit that starts kanata with the `pocket3.kbd` layout. |
| `systemd/system/kanata@.service` | Template unit — `systemctl enable kanata@caps` loads `caps.kbd`, etc. |
| `kanata/caps.kbd` | CapsLock → tap Esc / hold Fn-layer. Fn-layer provides media keys, mouse emulation (QWER/ASDF), browser back/forward. Targets Wooting, Fujitsu, AT, Cherry keyboards. |
| `kanata/cleware.kbd` | Cleware USB foot switch → mic mute (both keys). |
| `kanata/pocket3.kbd` | GPD Pocket 3 remap: CapsLock → tap Esc / hold RCtrl, Esc → tap CapsLock / hold RAlt, RShift → `<` (102nd key). |

#### `etc/profile.d/` — shell init scripts

| Script | What it does |
|--------|-------------|
| `00-local-bin.sh` | Adds `~/.local/bin`, `~/go/bin`, `/opt/dotfiles/.bin` to `$PATH`; sources `~/.cargo/env` if present. |
| `01-dircolors.sh` | Evaluates `dircolors -b` via the custom `/usr/local/bin/dircolors` wrapper. |
| `01-editor.sh` | `export EDITOR=nvim` |
| `dps.sh` | Defines `dps` / `dpsa` — formatted `docker ps` with alternating bold rows and multi-line port wrapping. |
| `ipinfo.sh` | `ipinfo <ip>` — queries ipinfo.io Lite API (token from `~/.secrets/ipinfo`). |

---

### `home/` — user configuration

#### Terminals

Both **Ghostty** and **WezTerm** share the **Kanagawa** colour scheme (`background #181616`, `foreground #c5c9c5`).

| Path | Details |
|------|---------|
| `.config/ghostty/config` | Font: Pragmasevka Nerd Font. Kanagawa palette. Unbinds Alt+1–9 (conflict with tmux over SSH). |
| `.config/wezterm/wezterm.lua` | Font: Pragmasevka Nerd Font. Kanagawa colours. Kitty keyboard protocol. Auto-generates SSH domains from `~/.ssh/config` (plain + multiplexed). **Windows**: detects OpenSSH agent pipe, builds launch menu (pwsh, PowerShell, cmd, Git Bash, Elvish, Nu, VS dev prompts). **Linux**: reads cursor theme/size from gsettings. |

#### tmux

| Feature | Detail |
|---------|--------|
| Plugins | TPM (auto-installed), tmux-sensible, tmux-fzf (`Ctrl-f`). |
| Keybindings | vi copy-mode (`v`/`y`), `r` reload config, `g` next pane, `n`/`p` next/prev window, `{`/`}` swap panes. |
| Status bar | Left: session name + attach count. Right: time + date, prefix/green indicator. Window tabs with Nerd Font icons for active, last, marked, zoomed, bell states. |
| Settings | 50k history, base-index 1, mouse on, 256color + RGB, extended-keys. |

#### Zsh

`etc/zsh/zshrc.local` — extends [grml-zsh-config](https://grml.org/zsh/) (`pacman -S grml-zsh-config`).

| Feature | Detail |
|---------|--------|
| History | 1M entries, dedup, ignore-space. |
| Modern replacements | `ls` → `lsd` (all aliases rewritten), `cat` → `bat --paging=never`. |
| File manager | `y` wrapper for yazi (cd-on-exit). |
| Fuzzy search | `fzf --zsh` integration (Ctrl-R etc.). |
| Node | Auto-loads nvm from `/usr/share/nvm/init-nvm.sh`. |
| tmux shortcut | `tmx` → `tmux new -As <hostname>` (auto-attach named session). |
| Docker aliases | `dc`, `dcu`, `dcd`, `dcr`, `dcdu`, `dcl`, `dcdul`, `dcp`, `dcpu`, `dcpul`, `dce`, `dcb`, `dcbn`, `dcbu`, `dcbnu` — full docker compose workflow. `dcpua` pulls all non-local images and recreates running compose services. |
| GitHub Copilot | `gc`, `ge` (explain), `gs` (suggest) via `gh copilot`. |
| Termux | OpenKeychain SSH agent setup when running in Termux. |
| Misc | `root` → `sudo su -`. |

#### SSH

| File | Purpose |
|------|---------|
| `.ssh/allowed_signers` | Maps `git@gottz.de` / `github@gottz.de` to trusted ed25519 + RSA signing keys (used by `gitconfig`'s `gpg.ssh.allowedSignersFile`). |
| `.ssh/authorized_keys` | Public keys authorised for SSH login. |

---

### `usr/` — helper executables & system overrides

#### `usr/local/bin/`

| Tool | What it does |
|------|-------------|
| `needsrestart` | Checks for deleted libs still held open by processes and compares running vs. installed kernel version. Exits non-zero if reboot needed. |
| `dpsql` | Connects to a Dockerized PostgreSQL: extracts `POSTGRES_USER`, `POSTGRES_PASSWORD`, `POSTGRES_DB` and container IP via `docker inspect`, then runs `psql`. Usage: `dpsql <container> [psql flags]`. |
| `loadavg` | Compiled C binary — prints 1/5/15 min load averages. |
| `colorcheck` | Awk script — prints a 77-column truecolor gradient to test terminal capabilities. |
| `dircolors` | Wrapper around `/usr/bin/dircolors` that prefers `~/.dircolors`, falls back to `/etc/DIR_COLORS`. |
| `lscolors` | Displays every `LS_COLORS` entry in its assigned colour with type descriptions. Useful for auditing the dircolors database. |

#### `usr/share/wireplumber/wireplumber.conf.d/`

| File | Purpose |
|------|---------|
| `no-suspend.conf` | Disables ALSA suspend for the Hidizs ST2 PRO USB DAC (avoids the ~2 s power-on ramp on resume). |

---

## Highlighted features

- **Kanagawa colour scheme** — consistent palette across Ghostty, WezTerm and tmux.
- **SSH-signed commits** — global git config enforces ed25519 signing for all commits and tags.
- **Keyboard remapping** — kanata layouts for CapsLock-as-Esc/Fn, GPD Pocket 3 fixes, and USB foot-switch mic-mute; managed by systemd.
- **Cross-platform WezTerm** — one config that works on Arch and Windows (SSH agent, launch menu, shell detection).
- **Docker workflow** — 15+ compose aliases, `dps` pretty-printer, `dcpua` bulk pull-and-recreate, `dpsql` container-aware psql.
- **Modern CLI** — lsd, bat, yazi, fzf integrated via zshrc; grml-zsh-config as base.
- **Hardened SSH** — key-only auth, 1 attempt, 10 s grace period.
- **Low-latency audio/USB** — modprobe and WirePlumber tweaks to disable power-save and suspend.

---

## Contributing

Issues, PRs and direct contact welcome.

- **Issues / Discussions** — [GitHub issue tracker](https://github.com/gottz/dotfiles/issues)
- **Contact** — <https://contact.gottz.de>
