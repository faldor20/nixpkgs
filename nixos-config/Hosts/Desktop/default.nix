# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, ... }:

let
  unstable = import <nixos-unstable> {
    overlays = [
    ];
    config = { allowUnfree = true; };
  };

in {
  imports = [ # Include the results of the hardware scan.
  /etc/nixos/hardware-configuration.nix
  ./drives.nix
  #    ./cachix.nix # this may need to be commented out untill cachx is installed corrrectly
  ];

 # fileSystems."/mnt/Media"={
 #	device= "/dev/disk/by-uuid/88CCA3E2CCA3C930";
 # fsType = "ntfs"; 
 # options = [ "rw" "uid=100"];


 # };
 # fileSystems."/mnt/Downloads"={
 # 	device="/dev/disk/by-uuid/EEB6ED84B6ED4E21";
 #   fsType = "ntfs";
 #   options = [ "rw" "uid=100"];
 # };
 # #  fileSystems."/mnt/Windows"={
 #   #       device="/dev/disk/by-uuid/0EE09F38E09F254D";
 #   #
 #   #  fsType = "ntfs";
 #   #      options = [ "rw" "uid=100"];
 #   # 	};
 #   fileSystems."/mnt/GamesStorage"={
 #     device=	"/dev/disk/by-uuid/A06E5D526E5D2278";
 #     fsType = "ntfs";
 #     options = [ "rw" "uid=100"];
 #   };


 #   services.nfs.server={
 #     enable=true;
 #     exports=''
 #             /share/main *(rw,nohide,no_subtree_check)
 #           '';
 #   };


    #boot.supportedFilesystems = [ "ntfs" ];
    #boot.loader.grub.enable=true;
    #boot.loader.grub.device= "/dev/sde";
    #boot.loader.grub.useOSProber=true;
    networking.hostName = "eli-nixos"; # Define your hostname.

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


#      #setup swapfile on btrfs
#      systemd.services = {
#        create-swapfile = {
#          serviceConfig.Type = "oneshot";
#          wantedBy = [ "swap-swapfile.swap" ];
#          script = ''
#            ${pkgs.coreutils}/bin/truncate -s 0 /swap/swapfile
#            ${pkgs.e2fsprogs}/bin/chattr +C /swap/swapfile
#            ${pkgs.btrfs-progs}/bin/btrfs property set /swap/swapfile compression none
#          '';
#        };
#      };
}
