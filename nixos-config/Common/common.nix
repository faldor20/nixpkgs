# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, variables, ... }:

let
  unstable = import <nixos-unstable> {
    overlays = [

    ];
    config = { allowUnfree = true; };
  };
  hostName = builtins.readFile ../Host;
  nix-hostsPath = ../Hosts;
  thisPath = ./.;
  commonPath = builtins.toString (thisPath + "/common.nix");
  hostConfig = nix-hostsPath + "/${hostName}/default.nix";
  #===Declarative cachix config===
  /*   imports = [
    (import (builtins.fetchTarball "https://github.com/jonascarpay/declarative-cachix/archive/a2aead56e21e81e3eda1dc58ac2d5e1dc4bf05d7.tar.gz"))
    ];

    cachix = [
    { name = "jmc"; sha256 = "1bk08lvxi41ppvry72y1b9fi7bb6qvsw6bn1ifzsn46s3j0idq0a"; }
    "iohk"
    ]; */

in
{

  environment.variables = {
    NIX_HOST = hostName;
  };
  nix = {
    autoOptimiseStore = true;
    nixPath = [
      "nixpkgs=/nix/var/nix/profiles/per-user/root/channels/nixos"
      "nixos-config=${commonPath}"
      "/nix/var/nix/profiles/per-user/root/channels"
    ];
    package = pkgs.nixFlakes;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };

  imports = [
    # Include the results of the hardware scan.
    ./cachix.nix # this may need to be commented out untill cachx is installed corrrectly
    hostConfig
  ];

  nix.trustedUsers = [ "root" "eli" ];
  location.provider = "geoclue2";
  services.geoclue2.enable = true;

  services.gvfs.enable = true;






  # fileSystems."/mnt/bfs1" = {
  #      device = "//10.141.206.27/Transfers";
  #      fsType = "cifs";
  #      options =  ["x-systemd.automount,noauto,x-systemd.idle-timeout=60,x-systemd.device-timeout=5s,x-systemd.mount-timeout=5s,credentials=/etc/nixos/smb-secrets-snb"];
  #  };
  #
  #  fileSystems."/export/eli" = {
  #    device = "/home/eli";
  #    options = [ "bind" ];
  #  };
  #  services.nfs.server.enable = true;
  #  services.nfs.server.exports = ''
  #    /export         10.41.57.91(rw,fsid=0,no_subtree_check)
  #    /export/eli  10.41.57.91(rw,nohide,insecure,no_subtree_check)
  #  '';
  #
  #services.samba = {
  #  enable = true;
  #package = pkgs.sambaFull;
  #  securityType = "user";
  #  extraConfig = ''
  #    workgroup = WORKGROUP
  #    server string = smbnix
  #    netbios name = smbnix
  #    security = user
  #    #use sendfile = yes
  #    #max protocol = smb2
  #    hosts allow = 10.41.57.  localhost
  #    hosts deny = 0.0.0.0/0
  #    guest account = nobody
  #    map to guest = Never
  #  '';
  #  shares = {
  #    private = {
  #      path = "/export/eli";
  #      browseable = "yes";
  #      "read only" = "no";
  #      "guest ok" = "no";
  #      "create mode"="0777";
  #      "directory mode"="0777";
  #      "valid users"="@wheel";
  #    };
  #  };
  #};

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.supportedFilesystems = [ "ntfs" ];

  #networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  # Set your time zone.
  time.timeZone = "Australia/Brisbane";

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;
  networking.nameservers = [ "185.228.168.9" "1.1.1.1" ];
  #systemd.services.systemd-udev-settle.enable = false;
  # systemd.services.NetworkManager-wait-online.enable = false;
  #networking.interfaces.wlp4s0.useDHCP = true;

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
  #services.xserver.desktopManager.plasma5.enable = true;
  services.xserver.windowManager.i3 = {
    enable = true;
    extraPackages = with pkgs; [
      dmenu #application launcher most people use
      i3status # gives you the default i3 status bar
      i3lock #default i3 screen locker
      i3blocks #if you are planning on using i3blocks over i3status
    ];
  };

  virtualisation.libvirtd.enable = true;

  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true; # so that gtk works properly
    extraPackages = with pkgs; [
      lxqt.lxqt-policykit
      swaylock-effects
      waybar
      swayidle
      wayvnc
      wl-clipboard
      mako # notification daemon
      wofi # Dmenu is the default in the config but i recommend wofi since its wayland native
      libappindicator # needed for tray icons
      sway-contrib.grimshot #handles screenshots
    ];
  };
  #run .desktop files in .config/autostart
  #essentially allows autostarting of applications taht use that method
  xdg.autostart.enable = true;

  # Remote desktop
  services.xrdp.enable = true;
  # change this if install sway
  services.xrdp.defaultWindowManager = "sway";
  #networking.firewall.allowedTCPPorts = [ 3389 ];

  # Configure keymap in X11
  # services.xserver.layout = "us";
  # services.xserver.xkbOptions = "eurosign:e";
  #--This enables caps2esc--
  # Map CapsLock to Esc on single press and Ctrl on when used with multiple keys.
  services.interception-tools = {
    enable = true;
    plugins = [ pkgs.interception-tools-plugins.caps2esc ];
    udevmonConfig =''
        - JOB: "${pkgs.interception-tools}/bin/intercept -g $DEVNODE | ${pkgs.interception-tools-plugins.caps2esc}/bin/caps2esc  | ${pkgs.interception-tools}/bin/uinput -d $DEVNODE"
          DEVICE:
            EVENTS:
              EV_KEY: [KEY_CAPSLOCK, KEY_ESC]
     '';
#      ''
#      - JOB: "${pkgs.interception-tools}/bin/intercept -g $DEVNODE | ${pkgs.interception-tools-plugins.caps2esc}/bin/caps2esc | ${pkgs.interception-tools}/bin/uinput -d $DEVNODE"
#      DEVICE:
#        EVENTS:
#          EV_KEY: [KEY_CAPSLOCK, KEY_ESC]
#    '';
  };
  # Enable CUPS to print documents.
  services.printing.enable = true;
  services.printing.drivers = [ pkgs.gutenprint ];

  # Enable sound.
  # sound.enable = true;
  hardware.pulseaudio = {
    enable = true;
    extraConfig =
      "load-module module-native-protocol-tcp auth-ip-acl=127.0.0.1"; # Needed by mpd to be able to use Pulseaudio
    extraModules = [ pkgs.pulseaudio-modules-bt ];
    package = pkgs.pulseaudioFull;
  };

  #Enable pipewrie sound
  /*
    security.rtkit.enable = true;
    services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
    };
  */
  services.mpd = {
    enable = true;
    dataDir = "/home/eli/.mpd/data";
    musicDirectory = "/home/eli/Music";
    user = "eli";
    extraConfig = ''
      audio_output {
      type "pulse" # MPD must use Pulseaudio
      name "Pulseaudio" # Whatever you want
      server "127.0.0.1" # MPD must connect to the local sound server
      }
    '';
  };
  # Enable touchpad support (enabled default in most desktopManager).
  #services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.eli = {
    isNormalUser = true;
    shell = pkgs.fish;
    extraGroups = [
      "libvirtd"
      "wheel"
      "docker"
      "video"
      "mpd"
      "networkmanager"
    ]; # Enable ‘sudo’ for the user.|Video is for backlight control
  };
  # user.users.mpd={
  #   group = cfg.group;
  #   extraGroups = [ "audio" ];
  #   description = "Music Player Daemon user";
  #   home = "${cfg.dataDir}";
  #
  # }
  security.sudo.enable = true;
  /*   security.doas.enable = true;
    security.doas.extraRules = [{
    users = [ "eli" ];
    keepEnv = true;
    }]; */

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; [
    # ====SYSTEM STUFF====
    htop
    fish
    oil
    kitty
    git
    wget
    zip
    ranger
    cachix
    #caps2esc
    #==== NIXOS====
    home-manager
    appimage-run
    nixfmt
    # ====EDITORS====
    vim
    neovim
    xdg-utils

    # FILESYSTEM
    fuse
  ];
  #docker
  virtualisation.docker.enable = true;
  #======FONTS=======
  fonts.fonts = with pkgs; [
    pkgs.emacs-all-the-icons-fonts
    font-awesome
    overpass
    ibm-plex
    (nerdfonts.override { fonts = [ "FiraCode" "DroidSansMono" ]; })
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji
    liberation_ttf
    fira-code-symbols
    mplus-outline-fonts
    dina-font
    jetbrains-mono
  ];
  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # =========Fixes for linux issues=========
  boot.kernel.sysctl = {
    #This is to fix issues reading and wirting to slow drives. data loss, stalling and no progress. linus torvald says the defualts are stupid these are better
    "vm.dirty_background_bytes" = 16777216;
    "vm.dirty_bytes" = 50331648;
  };

  # List services that you want to enable:
  services.gnome.gnome-keyring.enable = true;
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
  system.stateVersion = "21.11"; # Did you read the comment?
  systemd.services.nightoff = {
    serviceConfig = {
      ExecStart = "/home/eli/.config/nixpkgs/scripts/nightoff.sh";
    };
    wantedBy = [ "default.target" ];
  };
}
