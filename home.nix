{ config, pkgs, systemd, ... }:
let

  unstable = import <nixos-unstable> { config = { allowUnfree = true; }; };
  #sparkleshare_autostart = (pkgs.makeAutostartItem { name = "sparkleshare"; package = pkgs.sparkleshare; srcPrefix = "org.kde.";  });
in
{
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
  ];
  nixpkgs.overlays = [
    (self: super: {
      ffmpeg2 = super.ffmpeg-full.override { libvmaf = true; };
    })
  ];
  home.packages = with pkgs; [
    #====system====
    fortune
    sqlite
    htop
    gnome3.nautilus
    #====tools:====
    ranger
    sparkleshare
    catfish
    docker
    wireshark
    # sparkleshare_autostart
    # images:
    gimp
    inkscape
    #==== development====
    gitkraken
    unstable.libvmaf
    sshfs
    unstable.rustup
    unstable.dotnet-sdk_5
    #sccache
    # ====EDITORS====
    
    unstable.vscode
    vim
    #====WRITING====
     unstable.obsidian
    #====TOOLS for work:=====
    remmina
    # ====this is for managing nix-shell dependancies:====
    direnv
    niv
    # ====Basic software====
    ark
    gnumeric
    vlc
    mpd
    pavucontrol
    # mpc_cli
    # ====communications====
    teams
    #====highly specific utilities====
    fritzing
    #====theming====
    qgnomeplatform
    qtstyleplugin-kvantum-qt4
    libsForQt5.qtstyleplugin-kvantum
  ];
  # for development in nix:
  services.lorri.enable = true;

  programs = {
    emacs.enable = true;
    fish.enable = true;
    firefox.enable = true;
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

  services.mpd = {
    enable = true;
    musicDirectory = "~/Music";
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

    QT_QPA_PLATFORMTHEME = "gnome";
  };

}
