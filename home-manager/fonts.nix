{pkgs,lib,...}:
 {
fonts.fontconfig.enable = true;

  home.packages = with pkgs; [
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
}