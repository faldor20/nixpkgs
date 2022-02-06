#! /bin/bash
#This links the neovim config in here to te neovim config out there
ln -s ~/.config/nixpkgs/config/nvim ~/.config/nvim
ln -s ~/.config/nixpkgs/config/.doom.d ~/.doom.d
ln -s ~/.config/nixpkgs/config/waybar ~/.config/waybar
if test -f "/etc/nixos/configuration.nix"; then
    sudo mv /etc/nixos/configuration.nix /etc/nixos/configuration-backup.nix
fi
sudo ln -s ~/.config/nixpkgs/nixos-config/configuration.nix /etc/nixos/congiuration.nix

