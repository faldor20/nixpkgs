
{ config, pkgs, lib, ... }:

let
  unstable = import <nixos-unstable> {
    overlays = [
    ];
    config = { allowUnfree = true; };
  };

in {

  home.packages = with pkgs; [
    # images:
    #gimp
    #inkscape
    unstable.darktable
    #unstable.digikam
    #rawtherapee
    geeqie
    nomacs
    #mypaint
    #krita
  ];
}
