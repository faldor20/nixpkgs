
{ config, pkgs, lib, ... }:

let
  unstable = import <nixos-unstable> {
    overlays = [
    ];
    config = { allowUnfree = true; };
  };

in {

  nixpkgs.config.allowUnfree = true;
  imports=[
    ./dev-r.nix
  ];
  home.packages = with pkgs; [

    unstable.xournalpp
    anki
  ];
}
