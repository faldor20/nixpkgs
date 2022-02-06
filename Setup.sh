#!/usr/bin/env bash
SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
run(){
    nixHost=$1
    
    if [ "$EUID" -ne 0 ]; then
            echo "Please run this script as root"
            exit 1
    fi
    #This links the neovim config in here to te neovim config out there
    ln -s "$SCRIPT_DIR/config/nvim" ~/.config/nvim
    ln -s "$SCRIPT_DIR/config/.doom.d" ~/.doom.d
    ln -s "$SCRIPT_DIR/waybar" ~/.config/waybar
    if test -f "/etc/nixos/configuration.nix"; then
        sudo mv /etc/nixos/configuration.nix /etc/nixos/configuration-backup.nix
    fi

    export NIX_CONF_DIR=${nixHost?}
    echo "conf is at $NIX_CONF_DIR"
    nixos-rebuild boot
    
    exit 0
}

#Gets the paths and makes sure they all actually exist
NIX_P=$(echo $SCRIPT_DIR/nixos-config/Hosts | xargs find 2> /dev/null)

select file in $NIX_P 
do 
 echo "selected $file"
 run $file
done