{ config, pkgs, lib, ... }:


{

  #nixpkgs.config.allowUnfree = true;
  home.packages = with pkgs; [
#    flutter
  ];}
