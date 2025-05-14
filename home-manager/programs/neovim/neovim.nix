{ config, pkgs, unstable, ... }:

{
  # home.packages=[
  # pkgs.neovim-nightly
  # ];
  programs.neovim = {
    enable = true;
    package = unstable.neovim-unwrapped;
    extraPackages =  [
      unstable.nodePackages.vscode-langservers-extracted
      unstable.nodePackages.typescript-language-server
      #needed for the rocks package manager

      pkgs.imagemagick
      pkgs.luajit
    ];
    extraConfig = "";

    extraLuaPackages = ps: [ ps.magick ];
       # plugins= with plgs.vimplugins;
       #  [nvim-lspconfig
       #  completion-nvim];
  };
}
