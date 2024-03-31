{ config, pkgs, ... }:

{
  wayland.windowManager.sway = {
    enable = true;
#  wrapperFeatures.gtk = true ;
      config=null; #This means there is no defualt config added which may confict with my custom stuff
    extraConfig= (builtins.readFile ./config);
  
  };
home.packages = with pkgs; [
      lxqt.lxqt-policykit
      swaylock-effects
      waybar
      swayidle
      wayvnc
      wl-clipboard
      # mako # notification daemon
      wofi # Dmenu is the default in the config but i recommend wofi since its wayland native
      libappindicator # needed for tray icons
      sway-contrib.grimshot #handles screenshots
      xdg-desktop-portal
      xdg-desktop-portal-gtk
];
#notification daemon for sway
services.mako={
  enable=true;
  defaultTimeout=8000;


  extraConfig=''
    group-by=app-name

    font=Inconsolata
    background-color=#282828
    progress-color=#ebdbb2
    text-color=#d5c4a1

    border-color=#d65d0e
    border-size=5
    border-radius=2
    '';
};
}
