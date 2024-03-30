{ config, lib, pkgs, ... }:

{
  programs.git={
    enable=true;
    userName="Eli Dowling";
    userEmail="eli.jambu@gmail.com";
    signing={
      signByDefault=true;
      key=null;
    };
  };
}
