{ config,pkgs, ... }:

{
programs.fish={
    enable=true;
    shellAliases={
        doom ="~/.emacs.d/bin/doom";
        "!!"="commandline -i 'sudo $history[1]';history delete --exact --case-sensitive doh ";
        nixre= "sudo nixos-rebuild switch";
        hore="home-manager switch";
    };
    shellAbbrs={
        passwords= "visidata ~/Documents/quanteldesign.xlsx";
    };
    plugins=[
       {
            name = "direnv";
            src = pkgs.fetchFromGitHub {
                owner = "oh-my-fish";
              repo = "plugin-direnv";
              rev="0221a4d9080b5f492f1b56ff7b2dc6287f58d47f";
              sha256="04fax8vji1i8r1zrzidqrfxa11f89br2adlyh5lr1d2p1cmlqjz7";
            };
       }
    ];
    shellInit =
    "

     set QT_QPA_PLATFORMTHEME gnome
    set PATH ~/.dotnet/tools $PATH
    set PATH ~/bin $PATH
    set PATH ~/.cargo/bin $PATH
";
};
}
