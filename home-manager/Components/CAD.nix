{ config,unstable, pkgs, lib, ... }:

let


in {

  #nixpkgs.config.allowUnfree = true;
  imports=[
  ];
  home.packages = with pkgs; [
    # kicad
    f3d
    unstable.orca-slicer
  ];
}
