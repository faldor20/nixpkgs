# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, inputs,unstable,pkgs, lib, variables,nixpkgs, ... }:

let
  thisPath = ./.;
  commonPath = builtins.toString (thisPath + "/common.nix");

in
{

  nixpkgs={
    config={
      allowUnfree=true;
    };

  };

  nix = {
    registry = {
      nixpkgs.flake = nixpkgs;
    };
    settings.auto-optimise-store = false;
    optimise.automatic = true;
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 30d";
    };
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


  nix.settings.trusted-users = [ "root" "eli" ];
  location.provider = "geoclue2";
  services.geoclue2.enable = true;

  services.gvfs.enable = true;



  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.supportedFilesystems = [ "ntfs" ];
  boot.plymouth.enable=true;

  #networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  # Set your time zone.
  time = {
    timeZone = "Australia/Brisbane";
    hardwareClockInLocalTime = true;
  };
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
  #i18n.defaultLocale = "en_US.UTF-8";

  services.xserver.layout= "us";
   services.xserver.xkbVariant = "colemak_dh";

  # Enable the Plasma 5 Desktop Environment.
  services.xserver.enable = true;
  services.xserver.displayManager.sddm.enable = true;
  services.xserver.desktopManager.plasma5.enable = false;
  services.xserver.windowManager.i3 = {
    enable = true;
    # TODO install via home manager
    # extraPackages = with pkgs; [
    #   dmenu #application launcher most people use
    #   i3status # gives you the default i3 status bar
    #   i3lock #default i3 screen locker
    #   i3blocks #if you are planning on using i3blocks over i3status
    # ];
  };

  virtualisation.libvirtd.enable = true;

  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true; # so that gtk works properly
  };

  #We enable opengl because otherwires sway won't start 
  # hardware.opengl.enable=true;

  #run .desktop files in .config/autostart
  #essentially allows autostarting of applications taht use that method
  xdg.autostart.enable = true;




  programs.fuse.userAllowOther = true;


  

  #===rdp not allowed because of security===

  # Remote desktop
  #services.xrdp.enable = true;
  # change this if install sway
  #services.xrdp.defaultWindowManager = "sway";
  #networking.firewall.allowedTCPPorts = [ 3389 ];

  # Configure keymap in X11
  # services.xserver.layout = "us";
  # services.xserver.xkbOptions = "eurosign:e";
  
  # Enable CUPS to print documents.
  services.printing.enable = true;
  services.printing.drivers = [ pkgs.gutenprint ];

  # Enable sound.
  # sound.enable = true;
  hardware.pulseaudio = {
    enable = true;
    extraConfig =
      "load-module module-native-protocol-tcp auth-ip-acl=127.0.0.1"; # Needed by mpd to be able to use Pulseaudio
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
  # udev rules for connection of vial.
  services.udev.extraRules = ''
    KERNEL=="hidraw*", SUBSYSTEM=="hidraw", MODE="0666", TAG+="uaccess", TAG+="udev-acl"
  '';
  services.udev.packages=[
     (pkgs.writeTextFile {
        name = "voyger_udev";
        text = ''
        # Rules for Oryx web flashing and live training
        KERNEL=="hidraw*", ATTRS{idVendor}=="16c0", MODE="0664", GROUP="plugdev"
        KERNEL=="hidraw*", ATTRS{idVendor}=="3297", MODE="0664", GROUP="plugdev"

        # Keymapp Flashing rules for the Voyager
        SUBSYSTEMS=="usb", ATTRS{idVendor}=="3297", MODE:="0666", SYMLINK+="ignition_dfu"
        '';
        destination = "/etc/udev/rules.d/50-zsa.rules";
      })
  ];
  


  # Enable touchpad support (enabled default in most desktopManager).
  #services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.eli = {
    isNormalUser = true;
    shell = pkgs.fish;
    extraGroups = [
      "dialout"
      "fuse"
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
  #nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; [
    # ====SYSTEM STUFF====
    htop
    oil
    kitty
    git
    wget
    zip
    ranger

    #caps2esc
    #==== NIXOS====
    home-manager
    nixfmt
    # ====EDITORS====
    vim
    neovim
    xdg-utils

    # FILESYSTEM
    fuse
    # unstable.glibc
  ];

  programs.fish.enable=true;
  #docker
  virtualisation.docker.enable = true;

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  services.logind.lidSwitch = "suspend-then-hibernate";
  services.logind.extraConfig = ''
    IdleAction=suspend-then-hibernate
    IdleActionSec=10min
    	'';
  systemd.sleep.extraConfig = ''
    HibernateDelaySec=900s
  '';

  # =========Fixes for linux issues=========
  boot.kernel.sysctl = {
    #This is to fix issues reading and wirting to slow drives. data loss, stalling and no progress. linus torvald says the defualts are stupid these are better
    "vm.dirty_background_bytes" = 16777216;
    "vm.dirty_bytes" = 50331648;
  };

  # List services that you want to enable:
  services.gnome.gnome-keyring.enable = true;
  security.pam.services.sddm.enableGnomeKeyring = true;
  programs.ssh.startAgent = true;
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
  
  # systemd.services.nightoff = {
  #   serviceConfig = {
  #     ExecStart = "/home/eli/.config/nixpkgs/scripts/nightoff.sh";
  #   };
  #   wantedBy = [ "default.target" ];
  # };
  hardware.keyboard.zsa.enable = true;
  
}
