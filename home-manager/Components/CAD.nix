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
  ];
  home.packages = with pkgs; [
    kicad
  ];
}
