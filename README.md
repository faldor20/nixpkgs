# nixpkgs
How to install
1. get pre-iintall done, ike setup filesystem etc.
2. copy nix-config/configuration.nix and reaplce the origianl configuration.nix file that is generated aftering running "nixos-generate-config --root /mnt"
3. comment out cachix import in configuration.nix (around line 10), this can be readded after installing cachix
4.comment out any otehr unwanted stuff
5. continue with setup

