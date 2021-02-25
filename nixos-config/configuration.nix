# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:
let unstable = import <nixos-unstable> { config = { allowUnfree = true; }; };

in {
  imports = [ # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];
services.gvfs.enable = true;
 fileSystems."/mnt/bfs1" = {
      device = "//10.141.206.27/Transfers";
      fsType = "cifs";
      options =  ["x-systemd.automount,noauto,x-systemd.idle-timeout=60,x-systemd.device-timeout=5s,x-systemd.mount-timeout=5s,credentials=/etc/nixos/smb-secrets-snb"];
  };
  
  fileSystems."/export/eli" = {
    device = "/home/eli";
    options = [ "bind" ];
  };
  services.nfs.server.enable = true;
  services.nfs.server.exports = ''
    /export         10.41.57.91(rw,fsid=0,no_subtree_check) 
    /export/eli  10.41.57.91(rw,nohide,insecure,no_subtree_check) 
  '';

services.samba = {
  enable = true;
package = pkgs.sambaFull;
  securityType = "user";
  extraConfig = ''
    workgroup = WORKGROUP
    server string = smbnix
    netbios name = smbnix
    security = user 
    #use sendfile = yes
    #max protocol = smb2
    hosts allow = 10.41.57.  localhost
    hosts deny = 0.0.0.0/0
    guest account = nobody
    map to guest = Never
  '';
  shares = {
    private = {
      path = "/export/eli";
      browseable = "yes";
      "read only" = "no";
      "guest ok" = "no";
      "create mode"="0777";
      "directory mode"="0777";
      "valid users"="@wheel";
    };
  };
};


  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.supportedFilesystems = [ "ntfs" ];

  networking.hostName = "eli-nixos"; # Define your hostname.
  #networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Set your time zone.
  time.timeZone = "Australia/Brisbane";

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;
  networking.interfaces.eno1.useDHCP = true;
  networking.interfaces.wlp6s0.useDHCP = true;

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  # i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  # };

  # Enable the Plasma 5 Desktop Environment.
  services.xserver.enable = true;
  services.xserver.displayManager.sddm.enable = true;
  services.xserver.desktopManager.plasma5.enable = true;
 programs.sway = {
  enable = true;
  wrapperFeatures.gtk = true; # so that gtk works properly
  extraPackages = with pkgs; [
  lxqt.lxqt-policykit
    swaylock
    waybar
    swayidle
    wayvnc
    wl-clipboard
    mako # notification daemon
    wofi # Dmenu is the default in the config but i recommend wofi since its wayland native
  ];
  };
 #run .desktop files in .config/autostart
 #essentially allows autostarting of applications taht use that method
 xdg.autostart.enable=true;


  # Remote desktop
  services.xrdp.enable = true;
  # change this if install sway
  services.xrdp.defaultWindowManager = "sway";
  #networking.firewall.allowedTCPPorts = [ 3389 ];

  # Configure keymap in X11
  # services.xserver.layout = "us";
  # services.xserver.xkbOptions = "eurosign:e";
  #--This enables caps2esc--
  services.interception-tools.enable = true;
  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio = {
    enable=true;
    extraConfig = "load-module module-native-protocol-tcp auth-ip-acl=127.0.0.1"; # Needed by mpd to be able to use Pulseaudio
   
   };
 # services.mpd={
#  enable=true;
 # };
  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.eli = {
    isNormalUser = true;
    shell = pkgs.fish;
    extraGroups = [ "wheel" "docker" ]; # Enable ‘sudo’ for the user.
  };
  security.sudo.enable=true;
  security.doas.enable=true;
   security.doas.extraRules = [{
    users = [ "eli" ];
    keepEnv = true;
}];

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; [
    # ====SYSTEM STUFF====
    htop
    fish
    kitty
    git
    wget
    zip
   # caps2esc
    #==== NIXOS====
    home-manager
    appimage-run
    nixfmt
    # ====EDITORS====
    vim
    neovim

    firefox
    # FILESYSTEM
    fuse
    
  ];
  #systemd.packages=[pkgs.sparkleshare];
  #docker
  virtualisation.docker.enable = true;
  #======FONTS=======
  fonts.fonts = with pkgs; [
    pkgs.emacs-all-the-icons-fonts
font-awesome
    overpass
    ibm-plex
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji
    liberation_ttf
    fira-code
    fira-code-symbols
    mplus-outline-fonts
    dina-font
    proggyfonts
    jetbrains-mono
  ];
  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:
  services.gnome3.gnome-keyring.enable=true; 
  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "20.09"; # Did you read the comment?

}
