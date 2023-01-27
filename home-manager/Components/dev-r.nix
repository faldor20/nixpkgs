{ config, pkgs, lib, ... }:

let


in {

  #nixpkgs.config.allowUnfree = true;
  home.packages = with pkgs; [
    #---=====R====----
    rstudio
    R
    rPackages.languageserver
  ];}
