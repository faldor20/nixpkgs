
{ config, pkgs, lib, ... }:
{


  fileSystems."/mnt/Media"={
    device= "/dev/disk/by-uuid/88CCA3E2CCA3C930";
    fsType = "ntfs"; 
    options = [ "rw" "uid=100" "nofail"];
  };
  fileSystems."/mnt/Downloads"={
  	device="/dev/disk/by-uuid/EEB6ED84B6ED4E21";
    fsType = "ntfs";
    options = [ "rw" "uid=100" "nofail"];
  };
    fileSystems."/mnt/Windows"={
           device="/dev/disk/by-uuid/722AB9672AB928CD";
    
      fsType = "ntfs";
          options = [ "rw" "uid=100" "nofail"];
     	};
    fileSystems."/mnt/Storage"={
      device=	"/dev/disk/by-uuid/84B2FDDEB2FDD4A0";
      fsType = "ntfs";
      options = [ "rw" "uid=100" "nofail"];
    };
}