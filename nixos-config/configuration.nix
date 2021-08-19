# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

let
  unstable = import <nixos-unstable> {
    overlays = [
      (self: super:

        {
          logseq = super.logseq.overrideAttrs (old: rec {
     version = "0.2.6";
     pname="logseq";
     src = super.fetchurl {
       url = "https://github.com/logseq/logseq/releases/download/${version}/${pname}-linux-x64-${version}.AppImage";
       sha256 = "/tpegRGyGPviYpaSbWw7fH9ntvR7vUSD5rmwDMST5+Y=";
       name = "${pname}-${version}.AppImage";
    };

     appimageContents = super.appimageTools.extract {
       name = "${pname}-${version}";
       inherit src;
     };
          });
        })
    ];
    config = { allowUnfree = true; };
  };

in {
  imports = [ # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ./cachix.nix # this may need to be commented out untill cachx is installed corrrectly
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

  networking.hostName = "eli-nixos"; # Define your hostname.
  #networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager = {
    enable = true;
    wifi.backend = "iwd";
  };
  programs.nm-applet.enable = true;
  # Set your time zone.
  time.timeZone = "Australia/Brisbane";

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;
  networking.interfaces.enp0s31f6.useDHCP = true;
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
  services.xserver.desktopManager.pantheon.enable = true;
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
  services.interception-tools.enable = true;
  # Enable CUPS to print documents.
  services.printing.enable = true;

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
  security.doas.enable = true;
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
    oil
    kitty
    git
    wget
    zip
    ranger
    # caps2esc
    #==== NIXOS====
    home-manager
    appimage-run
    nixfmt
    # ====EDITORS====
    vim
    neovim
    xdg-utils
    # firefox
    # FILESYSTEM
    fuse
    #======laptop======
    #
    tlp
    powertop

    #
    #---endlaptop
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
  #======laptop=========
  # services.clight={
  #  enable=true;
  #};
  hardware.bluetooth.enable = true;
  services.blueman.enable = true;
 services.tlp = {
      enable = true;
      # extraConfig = ''
      settings = {
        # Detailked info can be found https://linrunner.de/tlp/settings/index.html

        # Disables builtin radio devices on boot:
        #   bluetooth
        #   wifi – Wireless LAN (Wi-Fi)
        #   wwan – Wireless Wide Area Network (3G/UMTS, 4G/LTE, 5G)
        # DEVICES_TO_DISABLE_ON_STARTUP="bluetooth wifi"

        # When a LAN, Wi-Fi or WWAN connection has been established, the stated radio devices are disabled:
        #   bluetooth
        #   wifi – Wireless LAN
        #   wwan – Wireless Wide Area Network (3G/UMTS, 4G/LTE, 5G)
        # DEVICES_TO_DISABLE_ON_LAN_CONNECT="wifi wwan"
        # DEVICES_TO_DISABLE_ON_WIFI_CONNECT="wwan"
        # DEVICES_TO_DISABLE_ON_WWAN_CONNECT="wifi"

        # When a LAN, Wi-Fi, WWAN connection has been disconnected, the stated radio devices are enabled.
        # DEVICES_TO_ENABLE_ON_LAN_DISCONNECT="wifi wwan"
        # DEVICES_TO_ENABLE_ON_WIFI_DISCONNECT=""
        # DEVICES_TO_ENABLE_ON_WWAN_DISCONNECT=""

        # Set battery charge thresholds for main battery (BAT0) and auxiliary/Ultrabay battery (BAT1). Values are given as a percentage of the full capacity. A value of 0 is translated to the hardware defaults 96/100%.
#        START_CHARGE_THRESH_BAT0=70;
    #    STOP_CHARGE_THRESH_BAT0=90;

        # Control battery feature drivers:
     #   NATACPI_ENABLE=1;
     #   TPACPI_ENABLE=1;
     #   TPSMAPI_ENABLE=1;

        # Defines the disk devices the following parameters are effective for. Multiple devices are separated with blanks.
        DISK_DEVICES="nvme0n1";

        # Set the “Advanced Power Management Level”. Possible values range between 1 and 255.
        #  1 – max power saving / minimum performance – Important: this setting may lead to increased disk drive wear and tear because of excessive read-write head unloading (recognizable from the clicking noises)
        #  128 – compromise between power saving and wear (TLP standard setting on battery)
        #  192 – prevents excessive head unloading of some HDDs
        #  254 – minimum power saving / max performance (TLP standard setting on AC)
        #  255 – disable APM (not supported by some disk models)
        #  keep – special value to skip this setting for the particular disk (synonym: _)
        DISK_APM_LEVEL_ON_AC="254 254";
        DISK_APM_LEVEL_ON_BAT="128 128";

        # Set the min/max/turbo frequency for the Intel GPU. Possible values depend on your hardware. See the output of tlp-stat -g for available frequencies.
        # INTEL_GPU_MIN_FREQ_ON_AC=0
        # INTEL_GPU_MIN_FREQ_ON_BAT=0
        # INTEL_GPU_MAX_FREQ_ON_AC=0
        # INTEL_GPU_MAX_FREQ_ON_BAT=0
        # INTEL_GPU_BOOST_FREQ_ON_AC=0
        # INTEL_GPU_BOOST_FREQ_ON_BAT=0

        # Selects the CPU scaling governor for automatic frequency scaling.
        # For Intel Core i 2nd gen. (“Sandy Bridge”) or newer Intel CPUs. Supported governors are:
        #  powersave – recommended (kernel default)
        #  performance
        # CPU_SCALING_GOVERNOR_ON_AC=powersave;
        # CPU_SCALING_GOVERNOR_ON_BAT=powersave;

        # Set Intel CPU energy/performance policy HWP.EPP. Possible values are
        #  performance
        #  balance_performance
        #  default
        #  balance_power
        #  power
        # for tlp-stat Version 1.3 and higher 'tlp-stat -p'
         CPU_ENERGY_PERF_POLICY_ON_AC="balance_performance";
         CPU_ENERGY_PERF_POLICY_ON_BAT="balance_power";

        # Set Intel CPU energy/performance policy HWP.EPP. Possible values are
        #   performance
        #   balance_performance
        #   default
        #   balance_power
        #   power
        # Version 1.2.2 and lower For version 1.3 and higher this parameter is replaced by CPU_ENERGY_PERF_POLICY_ON_AC/BAT
        # CPU_HWP_ON_AC=balance_performance;
        # CPU_HWP_ON_BAT=power;

        # Define the min/max P-state for Intel Core i processors. Values are stated as a percentage (0..100%) of the total available processor performance.
#        CPU_MIN_PERF_ON_AC=0;
 #       CPU_MAX_PERF_ON_AC=100;
  #      CPU_MIN_PERF_ON_BAT=0;
   #     CPU_MAX_PERF_ON_BAT=60;

        # Disable CPU “turbo boost” (Intel) or “turbo core” (AMD) feature (0 = disable / 1 = allow).
        CPU_BOOST_ON_AC=1;
       CPU_BOOST_ON_BAT=1;


        # Set Intel CPU energy/performance policy EPB. Possible values are (in order of increasing power saving):
        #   performance
        #   balance-performance
        #   default (deprecated: normal)
        #   balance-power
        #   power (deprecated: powersave)
        # Version 1.2.2 and lower For version 1.3 and higher this parameter is replaced by CPU_ENERGY_PERF_POLICY_ON_AC/BAT
        # ENERGY_PERF_POLICY_ON_AC=balance-performance;
        # ENERGY_PERF_POLICY_ON_BAT=power;

        # Timeout (in seconds) for the audio power saving mode (supports Intel HDA, AC97). A value of 0 disables power save.
        SOUND_POWER_SAVE_ON_AC=0;
        SOUND_POWER_SAVE_ON_BAT=1;

        # Controls runtime power management for PCIe devices.
        # RUNTIME_PM_ON_AC=on;
        # RUNTIME_PM_ON_BAT=auto;

        # Exclude PCIe devices assigned to listed drivers from runtime power management. Use tlp-stat -e to lookup the drivers (in parentheses at the end of each output line).
        # RUNTIME_PM_DRIVER_BLACKLIST="mei_me nouveau nvidia pcieport radeon"

        # Sets PCIe ASPM power saving mode. Possible values:
        #    default – recommended
        #    performance
        #    powersave
        #    powersupersave
        # PCIE_ASPM_ON_AC=default;
        # PCIE_ASPM_ON_BAT=default;
      #'';
      };
    };
  services.logind.lidSwitch = "suspend-then-hibernate";
  systemd.sleep.extraConfig = "HibernationDelaySec=1000";
  systemd.timers.suspend-on-low-battery = {
    wantedBy = [ "multi-user.target" ];
    timerConfig = {
      OnUnitActiveSec = "120";
      OnBootSec= "120";
    };
  };
  systemd.services.suspend-on-low-battery =
    let
      battery-level-sufficient = pkgs.writeShellScriptBin
        "battery-level-sufficient" ''
        test "$(cat /sys/class/power_supply/BAT0/status)" != Discharging \
          || test "$(cat /sys/class/power_supply/BAT0/capacity)" -ge 10
      '';
    in
      {
        serviceConfig = { Type = "oneshot"; };
        onFailure = [ "hibernate.target" ];
        script = "${battery-level-sufficient}/bin/battery-level-sufficient";
      };

  #-----endlaptop-----
  # List services that you want to enable:
  services.gnome.gnome-keyring.enable = true;
  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  networking.firewall.enable = false;

  networking.nameservers = [ "1.1.1.1" "9.9.9.9" ];
  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "21.11"; # Did you read the comment?
systemd.services.nightoff={
serviceConfig={
ExecStart= "/home/eli/bin/scripts/nightoff.sh";
};
wantedBy=["default.target"];
};
}
