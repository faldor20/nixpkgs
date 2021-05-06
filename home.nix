{ config, pkgs, systemd, ... }:
let

  unstable = import <nixos-unstable> { overlays=[

    (import (builtins.fetchTarball {
      url = https://github.com/mjlbach/emacs-overlay/archive/feature/flakes.tar.gz;
    }))
  ];

                                       config = { allowUnfree = true; }; };
  #sparkleshare_autostart = (pkgs.makeAutostartItem { name = "sparkleshare"; package = pkgs.sparkleshare; srcPrefix = "org.kde.";  });
vscodeInsiders = (unstable.vscode.override { isInsiders = true; }).overrideAttrs(oldAttrs: rec {
                       name = "vscode-insiders-${version}";
                       version = "1620235808";

                       src = pkgs.fetchurl {
                         name = "VSCode_latest_linux-x64.tar.gz";
                         url = "https://code.visualstudio.com/sha/download?build=insider&os=linux-x64";
                         sha256 = "1qlb8dpd0nk1vgf5sd3kykqz0cc6yv6rnhv5vqbc0wlx5x6ym1q8";
                       };
                     });
in
{
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
    ./neovim/neovim.nix
    ./sway/sway.nix
    ./git/git.nix
  ];
  nixpkgs.overlays = [
    (self: super: {
      ffmpeg2 = super.ffmpeg-full.override { libvmaf = true; };
    })

    (import (builtins.fetchTarball {
      url = https://github.com/nix-community/emacs-overlay/archive/30595e2d5a9fed7d668ea8b54763b728d83a7a7b.tar.gz;
    }))
  ];
  home.packages = with pkgs; [
    #====system====
    fortune
    sqlite
    htop
    gnome3.nautilus
    dolphin
    wev
    jmtpfs
    #====tools:====
    unstable.sparkleshare
    slurp
    catfish
    docker
    wireshark
    gnome3.seahorse
    # sparkleshare_autostart
    # images:
    gimp
    inkscape
    darktable
    mypaint
    krita
    #==== development====
    httpie
    git-lfs
    gitkraken
    unstable.libvmaf
    sshfs

    dotnetPackages.Paket
    gcc
    #binutils
    #clang
    #sccache
    #libudev
    #pkg-config
    #udev
    unstable.rustup
    unstable.rust-analyzer
    unstable.dotnet-sdk_5
    #sccache
    nim

    unstable.julia
    unstable.python3
    unstable.pipenv
    unstable.python38Packages.pip
    unstable.nodePackages.pyright
    # ====EDITORS====
    
    #unstable.vscode
    vscodeInsiders
    vim
    #====WRITING====
     unstable.obsidian
    #====TOOLS for work:=====
    remmina
    # ====this is for managing nix-shell dependancies:====
    direnv
    niv
    #====Basic software====
    ark
    gnumeric
    vlc
    mpd
    pavucontrol
    playerctl
    qutebrowser
    # mpc_cli
    # ====communications====
    teams
    #====highly specific utilities====
    fritzing
    #====theming====
    qgnomeplatform
    qtstyleplugin-kvantum-qt4
    libsForQt5.qtstyleplugin-kvantum
    #=======laptop=====
    brightnessctl
    #emacsPgtkGcc
    emacs
    firefox-wayland
    vivaldi
  ];
  # for development in nix:
  services.lorri.enable = true;

  programs = {
    #emacs.enable = true;
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
    theme =
      {
        name = "gruvbox-dark";
        package = unstable.gruvbox-dark-gtk;
      };
    # {
    # name = "Ant-Dracula";
    # package = pkgs.ant-dracula-theme;
    # };
  };
  dconf.enable = true;
  xsession.pointerCursor = {
    name = "Vanilla-DMZ";
    package = pkgs.vanilla-dmz;
    size = 128;
  };
  services.mpd = {
    enable = true;
    dataDir= "/home/eli/.mpd/data";
    musicDirectory = "/home/eli/Music";
    extraConfig = ''
      audio_output {
        type "pulse" # MPD must use Pulseaudio
        name "Pulseaudio" # Whatever you want
        server "127.0.0.1" # MPD must connect to the local sound server
      }
    '';
  };


  services.gpg-agent = {
    enable = true;
    defaultCacheTtl = 1800;
    enableSshSupport = true;
  };
  home.sessionVariables = {
    QT_SCALE_FACTOR=1.25;
    GDK_DPI_SCALE=1.25;
    QT_QPA_PLATFORMTHEME = "gnome";
  };

}
