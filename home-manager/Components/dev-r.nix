{ config, pkgs, lib, ... }:

let
  unstable = import <nixos-unstable> {
    overlays = [
    ];
    config = { allowUnfree = true; };
  };

in {

  nixpkgs.config.allowUnfree = true;
  home.packages = with pkgs; [
    #---=====R====----
    rstudio
    R
    rPackages.languageserver
  ];}
