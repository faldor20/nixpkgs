{
  unstable,
  config,
  pkgs,
  lib,
  ...
}:
{

  #nixpkgs.config.allowUnfree = true;
  home.packages = with pkgs; [

    beekeeper-studio
    dbeaver-bin
    unstable.redisinsight
    nix
    mysql-client
  ];
}
