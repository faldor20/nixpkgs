{pkgs,lib,...}:
 {
fonts.fontconfig.enable = true;

  home.packages = with pkgs; [
     emacs-all-the-icons-fonts
     font-awesome
     overpass
     ibm-plex
     #jetbrains-mono
     (nerdfonts.override { fonts = [ "FiraCode" "DroidSansMono" "JetBrainsMono"]; })
     noto-fonts
     noto-fonts-cjk
     noto-fonts-emoji
     liberation_ttf
     fira-code-symbols
     dina-font
  ];
}