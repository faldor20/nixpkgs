{ config, pkgs, lib, ... }:

let
  unstable = import <nixos-unstable> {
    overlays = [
    ];
    config = { allowUnfree = true; };
  };

buildDotnet = with unstable.dotnetCorePackages; combinePackages [
    sdk_6_0
    sdk_5_0
  ];
in {
  home.packages = with pkgs; [

    gitkraken
    powershell

    httpie
    git-lfs


    dotnetPackages.Paket
    #gcc
    gnumake

 #   unstable.swift
    unstable.clang


    #sccache
    #unstable.nim
    #unstable.nimlsp

    #clojure
    #jdk11
    #leiningen
    #clojure-lsp
    #
    #chromedriver

    #julia-stable


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
    unstable.rust-analyzer
    #unstable.dotnet-sdk_5
    #unstable.dotnet-sdk_6
    buildDotnet
    unstable.mono

    openssl.dev
    openssl.out
    openssl
  ];
}
