#!/usr/bin/env bash
SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
run(){
    nixHost=$1
    
    if [ "$EUID" -ne 0 ]; then
            echo "Please run this script as root"
            exit 1
    fi
    #This links the neovim config in here to te neovim config out there
    ln -s "$SCRIPT_DIR/config/nvim" /home/eli/.config/nvim
    ln -s "$SCRIPT_DIR/config/.doom.d" /home/eli/.config/.doom.d
    ln -s "$SCRIPT_DIR/waybar" /home/eli/.config/waybar
    #must make an mpd data directory
    mkdir /home/eli/.mpd
    mkdir /home/eli/.mpd/data
    mkdir /home/eli/.mpd/data/playlists

    if test -f "/etc/nixos/configuration.nix"; then
        sudo mv /etc/nixos/configuration.nix /etc/nixos/configuration-backup.nix
    fi

    export NIX_HOST="$nixHost"
    echo "$NIX_HOST"
    (echo -n "$nixHost")>$SCRIPT_DIR/nixos-config/Host
    export NIX_PATH="nixpkgs=/nix/var/nix/profiles/per-user/root/channels/nixos:nixos-config=$SCRIPT_DIR/nixos-config/Common/common.nix:/nix/var/nix/profiles/per-user/root/channels"
    echo "$NIX_PATH"
    #export NIX_CONFIG=""
    echo "conf is at $SCRIPT_DIR/nixos-config/Common/common.nix"
    nixos-rebuild switch --show-trace

    exit 0
}

#Gets the paths and makes sure they all actually exist
NIX_P=$(echo $SCRIPT_DIR/nixos-config/Hosts | xargs find 2> /dev/null)

select path in  $SCRIPT_DIR/nixos-config/Hosts/*; do
 file=${path##*/}
 echo "Selected $file"
 run $file
done
