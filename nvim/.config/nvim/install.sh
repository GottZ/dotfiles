#!/usr/bin/env bash
rm -rf ~/.local/share/nvim/site/pack/packer/start/packer.nvim
git clone --depth 1 https://github.com/wbthomason/packer.nvim ~/.local/share/nvim/site/pack/packer/start/packer.nvim
nvim -c "source lua/gottz/packer.lua|PackerSync"
nvim -c "source lua/gottz/packer.lua|PackerUpdate"
nvim -c "source lua/gottz/packer.lua|Mason"
nvim -c "source lua/gottz/packer.lua|TSUpdate"
nvim -c "source lua/gottz/packer.lua|checkhealth"
