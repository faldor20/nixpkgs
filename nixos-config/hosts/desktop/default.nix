# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ unstable ,config, pkgs, lib, ... }:


 {
  imports = [ # Include the results of the hardware scan.
  ../../common/common.nix
  ./hardware-configuration.nix
  ./drives.nix
  #    ./cachix.nix # this may need to be commented out untill cachx is installed corrrectly
  ];
    networking.hostName = "eli-nixos-desktop"; # Define your hostname.

    networking.networkmanager = {
      enable = true;
    };

    programs.nm-applet.enable = true;
    programs.steam.enable = true;


    #===================================DESKTOP===================================================
      #
      #
      boot.kernelPackages = pkgs.linuxPackages_latest;
      boot.initrd.kernelModules = [ "amdgpu" ];
      hardware.opengl.extraPackages = with unstable; [
        rocm-opencl-icd
        rocm-opencl-runtime
        amdvlk
      ];
      hardware.opengl.enable=true;
      hardware.opengl.driSupport = true;
      # For 32 bit applications
      hardware.opengl.driSupport32Bit = true;


}
