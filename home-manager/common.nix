{ inputs, unstable, config, pkgs, lib, systemd, ... }:
let

  aspellD = pkgs.aspellWithDicts (ps: with ps; [ en ]);
  local = ./.;
in
{

  # Enable home-manager and git
  programs.home-manager.enable = true;
  programs.git.enable = true;
  # configure basic home-manager settings
  home = {
    homeDirectory = "/home/eli";
    username = "eli";
    stateVersion = "22.11";
  };


  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";
  # nixpkgs.config = {
  #   virtualisation.docker.enable = true;
  #   allowUnfree = true;
  # };
  imports = [
    ./fonts.nix
    ./general/email.nix
    ./programs/fish/fish.nix
    ./programs/kitty/kitty.nix
    ./programs/sway/sway.nix
    ./programs/git/git.nix
    ./programs/neovim/neovim.nix
  ];
  #    ./neovim/neovim.nix
  # nixpkgs.overlays = [
  #   (self: super: { ffmpeg2 = super.ffmpeg-full.override { libvmaf = true; }; })
  #   #TODO: find a flakes approved way to do this
  #   # (import (builtins.fetchTarball {
  #   #   url =
  #   #     "https://github.com/nix-community/neovim-nightly-overlay/archive/28de4ebfc0ed628bfdfea83bd505ab6902a5c138.tar.gz";
  #   # }))

  # ];
  # xdg.configFile."helix/config.toml".source = "/home/eli/.config/nixpkgs/config/helix/config.toml";
  home.activation.linkMyFiles = config.lib.dag.entryAfter [ "writeBoundary" ] ''
    ln -s ${"/home/eli/.config/nixpkgs/config/helix/config.toml"} ~/.config/helix/config.toml
  '';
  home.packages = with pkgs; [


    gnome.file-roller
    glib
    fd
    #====system====
    #monitors
    x11_ssh_askpass
    nmon
    bpytop


    unzip
    fortune
    sqlite
    htop
    gnome3.nautilus

    cinnamon.nemo
    # gnomeExtensions.gsconnect
    gsettings-desktop-schemas
    dolphin
    wev
    jmtpfs
    st
    #partition-manager
    #======Nix Specific======
    nix-tree
    #======spelling=======
    (aspellWithDicts (dicts: with dicts; [ en en-computers en-science ]))
    #====tools:====
    #--screenshot
    sway-contrib.grimshot # allows taking screeenshots within sway
    #pdf
    zathura
    # mupdf
    # qpdf
    evince

    #libreoffice
    #==calculators===
    #qalculate-gtk
    speedcrunch
    #geogebra6

    gnome.gnome-system-monitor
    #unstable.zoom-us
    slurp
    pandoc
    catfish
    ncdu

    docker
    docker-compose
    #vagrant

    #virt-manager

    #wireshark
    minicom
    tio
    cutecom

    gnome3.seahorse

    gnome3.dconf-editor


    unstable.vial


    #texlive.combined.scheme-small
    #====Organization====
    #---calenmdar--
    #minetime
    #---email
    mailspring
    gnome3.geary

    aerc
    #---timers---
    gnome.pomodoro
    #==== development====
    #unstable.libvmaf
    sshfs

    steam-run
    appimage-run

    python39
    #unstable.pipenv
    python39Packages.pip
    #unstable.python38Packages.python-language-server
    #unstable.nodejs
    #unstable.nodePackages.pyright
    #unstable.nodePackages.yarn
    #electron
    ffmpeg
    # ====EDITORS====

    unstable.vscode-fhs
    #vscodeInsiders
    #neovim-nightly
    vim
    unstable.helix
    #====WRITING====
    #unstable.obsidian
    ghostwriter
    #unstable.obs-studio
    #unstable.logseq
    #unstable.remnote
    #typora
    #unstable.xournalpp
    #====TOOLS for work:=====
    #remmina

    # ====this is for managing nix-shell dependancies:====
    direnv
    niv
    rnix-lsp
    nil
    nixpkgs-fmt
    #====Basic software====
    ark

    feh
    #tixati
    qbittorrent
    gnumeric
    visidata
    #qutebrowser
    # mpc_cli
    lastpass-cli
    #--Media---
    vlc
    mpv
    #mpd
    pavucontrol
    playerctl
    #spotify-tui
    # ====communications====
    #teams
    unstable.discord
    #====highly specific utilities====
    #kinlde and ebooks
    calibre


    #fritzing
    #====theming====
    qgnomeplatform
    #qtstyleplugin-kvantum-qt4

   #libsForQt5.qtstyleplugins
   libsForQt5.qtstyleplugin-kvantum

    #pianobooster
    firefox-wayland
    google-chrome
    #vivaldi
    #=====UNI=====
    #octaveFull
    corectrl
    ldmtool
    #lutris
  ];
  # for development in nix:
  #removed in update to 22.11
  #services.lorri.enable = true;
  qt={
    enable=true;
    #platformTheme="gnome";
    style.name="Dracula";
    
  };

  programs = {

    emacs =

      {
        enable = false;
        package = unstable.emacsPgtkGcc;
      };
    fish.enable = true;
    #figure how to use the ~/Music option without breaking purity
    # ncmpcpp = {
    #   enable = false;
    #   mpdMusicDir = ~/Music;
    # };

  };
  gtk = {
    enable = true;
    #font = {
    #  name = "Noto Sans 10";
    #  package = pkgs.noto-fonts;
    #};
    iconTheme = {
      name = "Tela";
 #     package = (pkgs.tela-icon-theme.override { colorVariants = [ "purple" ]; });
      package = pkgs.tela-icon-theme;
    };
    theme={
      name="Dracula";
      package=unstable.dracula-theme;
    };
    # {
    # name = "Ant-Dracula";
    # package = pkgs.ant-dracula-theme;
    # };

  # gtk3.extraConfig = {
  #    gtk-cursor-theme-name = "volantes_cursors";
  #    gtk-application-prefer-dark-theme = "1";
  #  };
  #  gtk4.extraConfig = {
  #    gtk-cursor-theme-name = "volantes_cursors";
  #    gtk-application-prefer-dark-theme = "1";
  #  };
  };

         dconf = {
    enable = true;
settings={
"org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
      };
    };  };


 # xsession.pointerCursor = {
 #   name = "Vanilla-DMZ";
 #   package = pkgs.vanilla-dmz;
 #   size = 128;
 # };
  services = {
    wlsunset = {
      enable = true;
      latitude = "-27.47";
      longitude = "153.02";
    };
    #removed in update 22.11
    #   kdeconnect = {
    #     enable = true;
    #     indicator = true;
    #   };

    mpd = {
      dataDir = "/home/eli/.mpd/data";
      musicDirectory = "/home/eli/Music";
      extraConfig = ''
        audio_output {
          type "pulse" # MPD must use Pulseaudio
          name "Pulseaudio" # Whatever you want
          server "127.0.0.1" # MPD must connect to the local sound server
        }
      '';
    };
    # spotifyd = { enable = true; };
    #    udiskie = {
    #     enable = true;
    #     notify = false;
    #   };
    emacs = {
      enable = false;
      package = unstable.emacsPgtkGcc;
      client = { enable = true; };
    };
  };
  #removed in update 22.11
  #  services.gpg-agent = {
  #   enable = true;
  #   defaultCacheTtl = 1800;
  #   enableSshSupport = true;
  # };
  #services.network-manager-applet = { enable = true; };

  #  systemd.user = {
  #    services = {
  #      notes-syncer = {
  #        Unit = { Description = "git syncer for notes and stuff"; };
  #        Service = {
  #          Type = "simple";
  #          ExecStart = builtins.toString (local + "/scripts/Git-Syncers/notes.sh");
  #        };
  #      };
  #    };
  #    timers = {
  #      notes-syncer = {
  #        Unit = { Description = "git syncer Timer"; };
  #        Timer = {
  #          OnBootSec = "1min";
  #          OnUnitActiveSec = "15min";
  #          Unit = "notes-syncer";
  #        };
  #        Install = { WantedBy = [ "timers.target" ]; };
  #      };
  #    };
  #  };
  home.sessionVariables = {
    QT_QPA_PLATFORMTHEME = "gnome";
    QT_STYLE_OVERRIDE = "kvantum";
    GTK_THEME = "Dracula";
    XDG_DATA_DIRS = "${pkgs.gsettings-desktop-schemas}/share/gsettings-schemas/${pkgs.gsettings-desktop-schemas.name}:$XDG_DATA_DIRS";
    WLR_DRM_NO_MODIFIERS = 1;
       QT_SCALE_FACTOR = 1.25;
    QT_AUTO_SCREEfSCALE_FACTOR = 1;
        GDK_DPI_SCALE = 1.25;
    #TODO: did i need this??
    # OCL_ICD_VENDORS = "`nix-build '<nixpkgs>' --no-out-link -A rocm-opencl-icd`/etc/OpenCL/vendors/";
   # QT_QPA_PLATFORMTHEME = "gnome";
    NIXOS_OZONE_WL = "1";
    "_JAVA_AWT_WM_NONREPARENTING" = 1; # this fixes java apps in sway
  };

}
