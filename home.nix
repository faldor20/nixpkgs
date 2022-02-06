{ config, pkgs, systemd, ... }:
let
  unstable = import <nixos-unstable> {
    overlays = [
      (import ./logseq.nix)
                 (import ./pkgs/default.nix) ];

    config = { allowUnfree = true; };
  };

  aspellD = pkgs.aspellWithDicts (ps: with ps; [ en ]);
buildDotnet = with unstable.dotnetCorePackages; combinePackages [
    sdk_6_0
    sdk_5_0
  ];
  local=./.;
in {
  #Install instructions:
  #Pre install
  #
  #==emacs overlay:==
  #need to install cachix and run cachix use mjbach

  programs.home-manager.enable = true;
  nixpkgs.config = {
    virtualisation.docker.enable = true;
    allowUnfree = true;
  };
  imports = [
    ./fish/fish.nix
    ./kitty/kitty.nix
    ./sway/sway.nix
    ./git/git.nix
    ./general/email.nix
  ];
  #    ./neovim/neovim.nix
  nixpkgs.overlays = [
    (self: super: { ffmpeg2 = super.ffmpeg-full.override { libvmaf = true; }; })

    (import (builtins.fetchTarball {
      url =
        "https://github.com/nix-community/neovim-nightly-overlay/archive/master.tar.gz";
    }))
    (import (builtins.fetchTarball {
      url =
        "https://github.com/nix-community/emacs-overlay/archive/1b89e8a7a9ce1185140103ab35b5bf48704cc6d7.tar.gz";
    }))
  ];

  home.packages = with pkgs; [
    #(winetricks.override { wine = wineWowPackages.staging; })
    wineWowPackages.staging
    playonlinux
    gnome.file-roller
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
    gnome.networkmanagerapplet
    powershell
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
    # images:
    #gimp
    #inkscape
    unstable.darktable
    #unstable.digikam
    #rawtherapee
    geeqie
    nomacs
    #mypaint
    #krita
    feh
    anki
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
    httpie
    git-lfs
    gitkraken
    #unstable.libvmaf
    sshfs
    steam-run
    dotnetPackages.Paket
    #gcc
    gnumake

 #   unstable.swift
    unstable.clang

    #=====ocaml=====
    #unstable.opam
    #ocaml
    #gnumake
    #gcc
    #pkg-config
    openssl
    #m4
    #udev
    #libev
    #stdenv.cc
    #stdenv.cc.bintools
   # unstable.nodePackages.esy
    #----ocaml-----
    #binutils
    #clang
    #sccache
    #libudev
    #udev
    #
    pkg-config
  unstable.rustup
  unstable.rust-analyzer
    #unstable.dotnet-sdk_5
    #unstable.dotnet-sdk_6
    buildDotnet
    unstable.mono
    
    openssl.dev
    openssl.out
    openssl
    #sccache
    #unstable.nim
    #unstable.nimlsp

    #clojure
    #jdk11
    #leiningen
    #clojure-lsp
    #
    #chromedriver
    
    #julia-stable
    python3
    #unstable.pipenv
    python38Packages.pip
    #unstable.python38Packages.python-language-server
    #unstable.nodejs
    #unstable.nodePackages.pyright
    #unstable.nodePackages.yarn
    #electron
    ffmpeg
    # ====EDITORS====

    unstable.vscode
    #vscodeInsiders
    neovim-nightly
    vim
    #unstable.helix
    #====WRITING====
    #unstable.obsidian
    ghostwriter
    #unstable.obs-studio
    unstable.logseq
    #unstable.remnote
    #typora
    #unstable.xournalpp
    #====TOOLS for work:=====
    #remmina
    # ====this is for managing nix-shell dependancies:====
    direnv
    niv
    rnix-lsp
    nixpkgs-fmt
    #====Basic software====
    ark
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
    qtstyleplugin-kvantum-qt4
    libsForQt5.qtstyleplugin-kvantum
    #=======laptop=====
    brightnessctl
    wirelesstools # needed for wofi wifi script

    #emacsPgtkGcc
    #emacs
    #pianobooster
    firefox-wayland
    #unstable.google-chrome
    #vivaldi
    #=====UNI=====
    #octaveFull



    corectrl
    ldmtool

    #lutris
    
    

  ];
  # for development in nix:
  services.lorri.enable = true;

  programs = {
    emacs=
    { enable = true;
      package=pkgs.emacsPgtkGcc;};
    fish.enable = true;
    ncmpcpp = {
      enable = true;
      mpdMusicDir = ~/Music;
    };

  };
  gtk = {
    enable = true;
    #font = {
    #  name = "Noto Sans 10";
    #  package = pkgs.noto-fonts;
    #};
    iconTheme = {
      name = "oomox-gruvbox-dark";
      package = unstable.gruvbox-dark-icons-gtk;
    };
    theme = {
      name = "vimix-dark";
      package = unstable.vimix-gtk-themes;
    };
    # {
    # name = "Ant-Dracula";
    # package = pkgs.ant-dracula-theme;
    # };
  };
  dconf={
    enable = true;
  };

  xsession.pointerCursor = {
    name = "Vanilla-DMZ";
    package = pkgs.vanilla-dmz;
    size = 128;
  };
  services = {
    wlsunset={
      enable=true;
      latitude="-27.47";
      longitude="153.02";
    };

    kdeconnect={
    enable=true;
    indicator=true;};

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
    spotifyd = { enable = true; };
    udiskie = {
      enable = true;
      notify = false;
    };
    emacs={
    enable=true;
    package=pkgs.emacsPgtkGcc;
    client={enable=true;};
    };
  };
  services.gpg-agent = {
    enable = true;
    defaultCacheTtl = 1800;
    enableSshSupport = true;
  };
  services.network-manager-applet = { enable = true; };

  systemd.user = {
    services = {
      notes-syncer = {
        Unit = { Description = "git syncer for notes and stuff"; };
        Service = {
          Type = "simple";
          ExecStart = builtins.toString(local+"/scripts/Git-Syncers/notes.sh");
        };
      };
    };
    timers = {
      notes-syncer = {
        Unit = { Description = "git syncer Timer"; };
        Timer = {
          OnBootSec = "1min";
          OnUnitActiveSec = "15min";
          Unit = "notes-syncer";
        };
        Install = { WantedBy = [ "timers.target" ]; };
      };
    };
  };
  home.sessionVariables = {
    XDG_DATA_DIRS="${pkgs.gsettings-desktop-schemas}/share/gsettings-schemas/${pkgs.gsettings-desktop-schemas.name}:$XDG_DATA_DIRS";
    WLR_DRM_NO_MODIFIERS = 1;
 #   QT_SCALE_FACTOR = 1.25;
    QT_AUTO_SCREEN_SCALE_FACTOR = 1;
#    GDK_DPI_SCALE = 1.25;
    OCL_ICD_VENDORS="`nix-build '<nixpkgs>' --no-out-link -A rocm-opencl-icd`/etc/OpenCL/vendors/";
    QT_QPA_PLATFORMTHEME = "gnome";
    "_JAVA_AWT_WM_NONREPARENTING" = 1; # this fixes java apps in sway
  };

}
