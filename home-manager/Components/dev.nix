{ unstable, config, pkgs, lib, ... }:

let

#buildDotnet = with unstable.dotnetCorePackages; combinePackages [
#    sdk_6_0
#    sdk_5_0
#    aspnetcore_6_0
#];
in {

  #nixpkgs.config.allowUnfree = true;
  home.packages = with pkgs; [

    gitkraken
    gitui
    lazygit
    powershell
   

    httpie
    git-lfs


    #gcc
    gnumake
    cmake

 #   unstable.swift
    unstable.clang
    #unstable.platformio


    #sccache
    unstable.nim
    unstable.nimlsp

    #clojure
    #jdk11
    #leiningen
    #clojure-lsp
    #
    #chromedriver

    #julia-stable

    nodejs_20


    #=====ocaml=====
    #unstable.opam
    #ocaml
    #gnumake
    #gcc
    #pkg-config
    openssl
    #m4
    #udev
    #libev
    #stdenv.cc
    #stdenv.cc.bintools
   # unstable.nodePackages.esy
    #----ocaml-----
    #binutils
    #clang
    #sccache
    #libudev
    #udev
    #
    pkg-config
    unstable.rustup
    #unstable.rust-analyzer
    pipenv

    #unstable.dotnet-sdk_5
    #unstable.dotnet-sdk_6
    dotnetPackages.Paket
   # buildDotnet
    unstable.dotnet-sdk_7
    unstable.mono
    omnisharp-roslyn


    openssl.dev
    openssl.out
    openssl

    #=====nix====
    nil


    #====langServers===
    unstable.marksman
    pkgs.nodePackages.svelte-language-server
    pkgs.nodePackages.typescript-language-server
    pkgs.nodePackages.vscode-langservers-extracted 
 ];
}
