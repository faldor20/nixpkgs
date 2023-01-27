
{ unstable, config, pkgs, lib, ... }:

let


in {

  #nixpkgs.config.allowUnfree = true;
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
