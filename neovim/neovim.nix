{ config, pkgs, ... }:

{
  nixpkgs.overlays = [
    (import (builtins.fetchTarball {
      url = https://github.com/nix-community/neovim-nightly-overlay/archive/master.tar.gz;
    }))
  ];
  #home.packages=[
	#pkgs.neovim-nightly
  #];
  programs.neovim = {
    enable = true;
    package=pkgs.neovim-nightly;
    #extraConfig= (builtins.readFile ./init.vim);
#    plugins= with plgs.vimplugins;
 #     [nvim-lspconfig
 #     completion-nvim]
  };
}
