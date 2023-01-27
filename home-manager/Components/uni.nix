
{ config, pkgs, lib, ... }:

let


in {

  #nixpkgs.config.allowUnfree = true;
  imports=[
    ./dev-r.nix
  ];
  home.packages = with pkgs; [

    unstable.xournalpp
    anki
  ];
}
