{
  inputs,
  unstable,
  config,
  pkgs,
  lib,
  systemd,
  ...
}:
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
    stateVersion = "23.05";
  };

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";
  # nixpkgs.config = {
  #   virtualisation.docker.enable = true;
  #   allowUnfree = true;
  # };
  imports = [
    # ./stylix.nix
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
  # home.activation.linkMyFiles = config.lib.dag.entryAfter [ "writeBoundary" ] ''
  #   ln -s ${"/home/eli/.config/nixpkgs/config/lazygit/config.yml"} ~/.config/lazygit/config.yml
  #   ln -s ${"/home/eli/.config/nixpkgs/config/helix/config.toml"} ~/.config/helix/config.toml
  # '';
  #

  # This is for steel support of helix. stolen from here: https://github.com/clo4/nix-dotfiles/blob/main/modules/home/robert.nix
 home.file.".local/share/steel" = {
    source = pkgs.helix-cogs;
    recursive = true;
  };
  home.sessionVariables.STEEL_HOME = "$HOME/.local/share/steel";
  home.sessionVariables.STEEL_LSP_HOME = "$HOME/.local/share/steel/steel-language-server";

    home.file = {
    lazygit = {
      source = config.lib.file.mkOutOfStoreSymlink "/home/eli/.config/nixpkgs/config/lazygit/config.yml";
      target = ".config/lazygit/config.yml";
    };
    helix = {
      source = config.lib.file.mkOutOfStoreSymlink "/home/eli/.config/nixpkgs/config/helix/config.toml";
      target = ".config/helix/config.toml";
    };
    wallpaper = {
      source = config.lib.file.mkOutOfStoreSymlink "/home/eli/.config/nixpkgs/assets/wallpaper.jpg";
      target = "Downloads/wallpaper.jpg";
    };
    helix-langs = {
      source = config.lib.file.mkOutOfStoreSymlink "/home/eli/.config/nixpkgs/config/helix/languages.toml";
      target = ".config/helix/languages.toml";
    };
    spotify-player = {
      source = config.lib.file.mkOutOfStoreSymlink "/home/eli/.config/nixpkgs/config/spotify-player/app.toml";
      target = ".config/spotify-player/app.toml";
    };
    ".profile".text = ''
      export PATH="/home/eli/Programming/scripts:/home/eli/.cargo/bin:/home/eli/bin:/home/eli/.dotnet/tools:$PATH"
      export EDITOR="hx"
      export VISUAL="hx"
      export TERMINAL="kitty"
    '';
    # ".config/sway"
  };
  home.packages = with pkgs; [
    easyeffects
    just
    unstable.jujutsu
    #needed for jujutsu
    # unstable.watchman

    pavucontrol

    jq
    #for some reason the normal version of wget is from busybox and brakes some things
    wget

    gnome.file-roller
    vulkan-tools
    fd
    broot
    #====system====
    #monitors
    x11_ssh_askpass
    nmon
    btop

    unzip
    fortune
    sqlite
    htop
    gnome3.nautilus
    xplr

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
    (aspellWithDicts (
      dicts: with dicts; [
        en
        en-computers
        en-science
      ]
    ))
    #====tools:====
    #--screenshot
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
    pandoc
    xfce.catfish
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
    gnome3.geary

    aerc
    #---timers---
    gnome.pomodoro
    #==== development====
    #unstable.libvmaf
    sshfs

    steam-run
    (appimage-run.override {
      extraPkgs =
        pkgs: with pkgs; [
          libthai
          libsecret
        ];
    })
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
    # zed-editor-new
    #vscodeInsiders
    #neovim-nightly
    vim
    helix
    helix-cogs
    steel-pkg

    #====WRITING====
    unstable.obsidian
    ghostwriter
    #unstable.obs-studio
    unstable.logseq
    unstable.remnote
    #typora
    #unstable.xournalpp
    #====TOOLS for work:=====
    super-productivity
    #remmina

    # ====this is for managing nix-shell dependancies:====
    niv
    nil
    nixpkgs-fmt
    #====Basic software====
    ark

    feh
    #tixati
    unstable.qbittorrent
    # gnumeric
    # visidata
    #qutebrowser
    # mpc_cli
    lastpass-cli
    #--Media---
    vlc
    mpv
    spotify-player
    unstable.psst
    #mpd
    playerctl
    #spotify-tui
    # ====communications====
    #teams
    unstable.discord
    #====highly specific utilities====
    #kinlde and ebooks
    # calibre

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
  qt = {
    enable = true;
    #platformTheme="gnome";
    style.name = "Dracula";
  };

  ##Setup gpg
  programs.gpg.enable = true;
  services.gpg-agent = {
    enable = true;
    defaultCacheTtl = 34560000;
    maxCacheTtl = 34560000;
    pinentryPackage = pkgs.pinentry-tty;
    enableScDaemon = true;
  };

  programs = {
    direnv = {
      enable = true;
      # enableFishIntegration = true; # see note on other shells below
      nix-direnv.enable = true;
    };
    zoxide = {
      enable = true;
      enableFishIntegration = true; # see note on other shells below
    };
    fzf={
      enable=true;
      enableFishIntegration = true;

    };
    nnn = {
      enable = true;
      package = pkgs.nnn.override ({ withNerdIcons = true; });
      plugins = {

        mappings = {
          c = "fzcd";
          f = "finder";
          v = "imgview";
        };
      };
    };

    emacs = {
      enable = true;
      package = unstable.emacs;
      # client = { enable = true; };
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
    iconTheme = {
      name = "Tela";
      #     package = (pkgs.tela-icon-theme.override { colorVariants = [ "purple" ]; });
      package = pkgs.tela-icon-theme;
    };
    theme = {
      name = "Dracula";
      package = unstable.dracula-theme;
    };
  };

  dconf = {
    enable = true;
    settings = {
      "org/gnome/desktop/interface" = {
        color-scheme = "prefer-dark";
      };
    };
  };

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
    #Removed for update to 23.11
    # QT_STYLE_OVERRIDE = "kvantum";
    GTK_THEME = "Dracula";
    # XDG_DATA_DIRS = "${pkgs.gsettings-desktop-schemas}/share/gsettings-schemas/${pkgs.gsettings-desktop-schemas.name}:$XDG_DATA_DIRS";

    # WLR_DRM_NO_MODIFIERS = 1;
    # QT_SCALE_FACTOR = 1.25;
    # QT_AUTO_SCREEfSCALE_FACTOR = 1;
    # GDK_DPI_SCALE = 1.25;

    #TODO: did i need this??
    # OCL_ICD_VENDORS = "`nix-build '<nixpkgs>' --no-out-link -A rocm-opencl-icd`/etc/OpenCL/vendors/";
    # QT_QPA_PLATFORMTHEME = "gnome";
    NIXOS_OZONE_WL = "1";
    "_JAVA_AWT_WM_NONREPARENTING" = 1; # this fixes java apps in sway

    #!!! THESE VARIABLES ARE NOT CORRECTLY INJECTED INTO ALL ENVIROMENTS
    #   PATH = "~/Programming/scripts:~/.cargo/bin:~/bin:~/.dotnet/tools:$PATH";
    #   EDITOR = "hx";
    #   VISUAL = "hx";
    #   TERMINAL = "kitty";
  };

  systemd.user.sessionVariables = {

    PATH = "~/Programming/scripts:~/.cargo/bin:~/bin:~/.dotnet/tools:$PATH";
    EDITOR = "hx";
    VISUAL = "hx";
    TERMINAL = "kitty";
};

    # xdg.portal = {
  #   enable = true;
  #   extraPortals = [ pkgs.xdg-desktop-portal-wlr pkgs.xdg-desktop-portal-gtk ];
  #   configPackages = [ pkgs.sway ];
  # };
  # xdg.mimeApps = {
  #    enable = true;
  #    defaultApplications = {
  #      "text/*" = ["Helix.desktop"];
  #    };
  #  };
}
