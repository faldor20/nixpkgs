# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, ... }:

let

  components=../../Components;
in {

  # #nixpkgs.config.allowUnfree = true;
  imports=[
    ../../common.nix
    #"${components}/uni.nix"
    
    "${components}/dev.nix"
    "${components}/CAD.nix"
  ];
  home.packages = with pkgs; [
    brightnessctl
    wirelesstools # needed for wofi wifi script

    gnome.gnome-power-manager
    


  ];
  systemd.user.services.monitor-scale= {
      Service={
        Environment = [
          "PATH=${lib.makeBinPath (with pkgs; [ fish jq sway ])}"
        ];
        ExecStart = "/home/eli/.config/nixpkgs/scripts/monitorScale.fish";
      };
      Install={
          WantedBy = [ "default.target" ];
      };
  };
}
