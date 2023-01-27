{ config, pkgs, lib, ... }:

let


in {

  #nixpkgs.config.allowUnfree = true;
  home.packages = with pkgs; [
    #(winetricks.override { wine = wineWowPackages.staging; })
    wineWowPackages.staging
    playonlinux
  ];
}
