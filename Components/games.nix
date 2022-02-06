{ config, pkgs, lib, ... }:

let
  unstable = import <nixos-unstable> {
    overlays = [
    ];
    config = { allowUnfree = true; };
  };

in {

  home.packages = with pkgs; [
    #(winetricks.override { wine = wineWowPackages.staging; })
    wineWowPackages.staging
    playonlinux
  ];
}
