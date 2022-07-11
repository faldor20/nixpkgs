#!/usr/bin/env bash
SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
run(){
    nixHost=$1
    
    if [ "$EUID" -ne 0 ]; then
            echo "Please run this script as root"
            exit 1
    fi

    if test -f "/etc/nixos/configuration.nix"; then
        sudo mv /etc/nixos/configuration.nix /etc/nixos/configuration-backup.nix
    fi

    echo 'Adding nixos unstable and updating, this could take a fair while'
    nix-channel --add https://nixos.org/channels/nixos-unstable nixos-unstable
    nix-channel --update -v
    
    export NIX_HOST="$nixHost"
    echo "$NIX_HOST"
    (echo -n "$nixHost")>$SCRIPT_DIR/nixos-config/Host
    export NIX_PATH="nixpkgs=/nix/var/nix/profiles/per-user/root/channels/nixos:nixos-config=$SCRIPT_DIR/nixos-config/Common/common.nix:/nix/var/nix/profiles/per-user/root/channels"
    echo "$NIX_PATH"
    #export NIX_CONFIG=""
    echo "conf is at $SCRIPT_DIR/nixos-config/Common/common.nix"
    nixos-rebuild switch --show-trace 2>&1 | tee buildlog.log

    exit 0
}

#Gets the paths and makes sure they all actually exist
NIX_P=$(echo $SCRIPT_DIR/nixos-config/Hosts | xargs find 2> /dev/null)

select path in  $SCRIPT_DIR/nixos-config/Hosts/*; do
 file=${path##*/}
 echo "Selected $file"
 run $file
done
