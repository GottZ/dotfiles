# GottZ Dotfiles Repository

A curated collection of my configuration files, helper scripts and system‑wide settings for a primarily **arch‑based** workstation.  
The repo is kept in `/opt/dotfiles` and is intended to be managed as root (or with sudo) because many of the files live under `/etc`, `/usr/local/bin` and systemd unit directories, being able to just get symlinked from the repo.

---

## Quick start

```bash
# clone the repo (as root or with sudo)
sudo git clone https://github.com/gottz/dotfiles.git /opt/dotfiles

# placeholder script (future symlink manager)
/opt/dotfiles/.bin/dotfiles

# create symlinks for the pieces you need, e.g.
ln -s /opt/dotfiles/etc/gitconfig      /etc/gitconfig
ln -s /opt/dotfiles/etc/DIR_COLORS    /etc/DIR_COLORS
ln -s /opt/dotfiles/etc/profile.d/*   /etc/profile.d/
ln -s /opt/dotfiles/usr/local/bin/*   /usr/local/bin/
ln -s /opt/dotfiles/home/.config/*    $HOME/.config/
```

Future versions will automate the above with a proper installer, but for now manual symlinks are the most transparent method.

---

## Repository layout & purpose

| Path | Type | What it does |
|------|------|--------------|
| `etc/` | system configuration | Global settings for `git`, `dircolors`, `systemd`, `modprobe`, `docker`, `ssh`, `sudoers`, etc. |
| `etc/gitconfig` | git config file | Sets user identity, enables GPG‑signing of commits/tags, forces rebase on pull, and configures SSH‑based signing via `~/.ssh/allowed_signers`. |
| `etc/DIR_COLORS` | dircolors database | Provides a rich colour palette for `ls --color`. |
| `etc/profile.d/` | shell init scripts | Adds `$HOME/.local/bin` to `PATH` (`00‑local‑bin.sh`), loads the DIR_COLORS file (`01‑dircolors.sh`), selects the preferred editor (`01‑editor.sh`), and supplies a few handy utilities (`dps.sh`, `ipinfo.sh`). |
| `etc/kanata/` | keyboard layout definitions (kanata) | Custom key‑maps for ergonomic keyboards (`caps.kbd`, `cleware.kbd`, `pocket3.kbd`). |
| `etc/docker/__hetzner.daemon.json` | Docker daemon config | Example daemon configuration for Hetzner cloud nodes. |
| `etc/modprobe.d/` | kernel module options | Power‑saving tweaks for sound and USB devices. |
| `etc/pacman.d/hooks/` | pacman hook | Removes old package cache after upgrades (`remove_old_cache.hook`). |
| `etc/systemd/system/` | systemd unit files | Service for the `kanata` keyboard remapper (both template and instance units). |
| `etc/ssh/sshd_config.d/99-gottz.conf` | sshd fragment | Hardened SSH daemon settings. |
| `etc/sudoers.d/00_timeout` | sudoers fragment | Reduces sudo password timeout. |
| `etc/zsh/zshrc.local` | Zsh personal config | Small additions to the upstream `grml‑zsh‑config`. |
| `home/.config/ghostty/` | Ghostty terminal config | Preferred Ghostty settings. |
| `home/.config/tmux/` | tmux config | Custom status line and key bindings. |
| `home/.config/wezterm/` | WezTerm config | Lua‑based terminal configuration. |
| `usr/local/bin/` | helper executables | Small utilities (`colorcheck`, `dircolors`, `dpsql`, `loadavg`, `lscolors`, `needsrestart`). |
| `.bin/dotfiles` | bootstrap script | Simple wrapper that cd’s into the repo; a placeholder for future automation. |

---

## Highlighted features

* **Modern Zsh** – based on *grml‑zsh‑config* with customizations and a colourful `tmux` status bar.
* **Keyboard remapping** – `kanata` layouts for ergonomic keyboards; a systemd service keeps the daemon running.
* **Git commit signing** – global git config enforces SSH‑based GPG signing for all commits and tags.
* **Convenient CLI tools** – `needsrestart` checks for pending service restarts, `loadavg` visualises system load, `dpsql` is a tiny wrapper for `psql`, etc.
* **Portable colour scheme** – `DIR_COLORS` and accompanying `dircolors` script give a consistent `ls` colour palette across terminals.
* **System‑wide power‑saving tweaks** – `modprobe.d` snippets reduce USB and audio power consumption on laptops.

---

## Contributing

Feel free to open issues, submit pull requests, or contact the author directly.

* **Issues / Discussions** – Use the GitHub repository’s issue tracker.
* **Contact** – <https://contact.gottz.de>

When contributing, keep the repository tidy: add new files under the appropriate directory and update this README accordingly.

---

