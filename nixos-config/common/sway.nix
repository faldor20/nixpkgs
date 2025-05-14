{ config, pkgs,lib, ... }:

let
  dbus-sway-environment = pkgs.writeTextFile {
    name = "dbus-sway-environment";
    destination = "/bin/dbus-sway-enviroment";
    executable = true;

    text = ''
      dbus-update-activation-enviroment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP=sway
      systemctl --user stop pipewire pipewire-media-session xdg-desktop-portal xdg-desktop-portal-wlr
      systemctl --user start pipewire pipewire-media-session xdg-desktop-portal xdg-desktop-portal-wlr
    '';
  };

  configure-gtk = pkgs.writeTextFile {
    name = "configure-gtk";
    destination = "/bin/configure/-gtk";
    executable = true;
    text = let
      schema = pkgs.gsettings-desktop-schemas;
      datadir = "${schema}/share/gsetting-schemas/${schema.name}";
    in ''
      export XDG_DATA_DIRS=${datadir}:$XDG_DATA_DIRS
      gnome_schema=org.gnome.desktop.interface
      # gsettings set $gnome_schema gtk-theme 'WhiteSur-dark'
      # gsettings set $gnome_schema cursor-theme 'capitaine-cursors-white'
    '';
  };
in {
  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true; # so that gtk works properly
  };


  services.dbus.enable = true;
  xdg.portal = {
    enable = true;
    wlr.enable = true;

    # gtk portal needed to make gtk apps happy
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };
  environment.sessionVariables = {
    XDG_CACHE_HOME = "$HOME/.cache";
    XDG_CONFIG_HOME = "$HOME/.config";
    
    XDG_DATA_DIRS = lib.mkForce "/usr/local/share/:/usr/share/";
    
    XDG_DATA_HOME = "$HOME/.local/share";
    XDG_STATE_HOME = "$HOME/.local/state";
  };
  environment.systemPackages = with pkgs; [
    sway
    dbus-sway-environment
    configure-gtk
    wayland
    xdg-utils

    sway-contrib.grimshot # handles screenshots
    slurp
    wl-clipboard
    wl-color-picker
    hyprpicker

    lxqt.lxqt-policykit
    swaylock-effects
    waybar
    swayidle
    wayvnc
    wl-clipboard
    wofi # Dmenu is the default in the config but i recommend wofi since its wayland native
    libappindicator # needed for tray icons
  ];

  #run .desktop files in .config/autostart
  #essentially allows autostarting of applications taht use that method
  xdg.autostart.enable = true;

  services.greetd = {
    enable = true;
    settings = rec {
      initial_session = {
        command = "${pkgs.sway}/bin/sway";
        user = "eli";
      };
      default_session = initial_session;
    };
  };
}
