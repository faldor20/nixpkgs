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
      mako # notification daemon
      wofi # Dmenu is the default in the config but i recommend wofi since its wayland native
      libappindicator # needed for tray icons
      sway-contrib.grimshot #handles screenshots
];
}
