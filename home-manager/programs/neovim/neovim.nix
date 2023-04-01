{ config, pkgs,unstable, ... }:

{
  # nixpkgs.overlays = [
  #   (import (builtins.fetchTarball {
  #     url = https://github.com/nix-community/neovim-nightly-overlay/archive/master.tar.gz;
  #   }))
  # ];
  #home.packages=[
	#pkgs.neovim-nightly
  #];
  programs.neovim = {
    enable = true;
    package=unstable.neovim-unwrapped;
    extraPackages=[
    unstable.nodePackages.vscode-langservers-extracted
    unstable.nodePackages.typescript-language-server   
     ];
    extraConfig= "";
#    plugins= with plgs.vimplugins;
 #     [nvim-lspconfig
 #     completion-nvim]
  };
}
