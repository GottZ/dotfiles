#!/usr/bin/env bash
root="$( dirname -- "$( readlink -f -- "$0"; )"; )"
rm -rf ~/.config/nvim
rm -rf ~/.config/tmux
ln -s "$root/nvim/.config/nvim" ~/.config/nvim
ln -s "$root/tmux/.config/tmux" ~/.config/tmux
