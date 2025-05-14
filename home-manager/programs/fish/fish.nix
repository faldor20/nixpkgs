{ config, pkgs, ... }:

{
  programs.fish = {
    enable = true;
    shellAliases = {
      doom = "~/.emacs.d/bin/doom";
      "!!" = "commandline -i 'sudo $history[1]';history delete --exact --case-sensitive doh ";
      nixre = "sudo nixos-rebuild switch";
      hore = "home-manager switch";
    };
    shellAbbrs = {
      passwords = "visidata ~/Documents/quanteldesign.xlsx";
    };
    plugins = [
      # {
      # disabled in favour of direnv program
      # name = "direnv";
      # src = pkgs.fetchFromGitHub {
      #     owner = "oh-my-fish";
      #   repo = "plugin-direnv";
      #   rev="0221a4d9080b5f492f1b56ff7b2dc6287f58d47f";
      #   sha256="04fax8vji1i8r1zrzidqrfxa11f89br2adlyh5lr1d2p1cmlqjz7";
      # };
      # }
    ];
    functions = {

      add-proj = {
        body = ''
          set current_dir (basename $PWD)
          set target_dir ~/p/$current_dir

          if test -e $target_dir
              echo "Error: $target_dir already exists."
              return 1
              quit
          end

          ln -s $PWD $target_dir
          echo "Symlink created: $target_dir -> $PWD"
        '';
      };
    };
    shellInit = ''
      set QT_QPA_PLATFORM wayland
      set GDK_BACKEND wayland
      set XDG_SESSION_TYPE wayland
      set MOZ_ENABLE_WAYLAND 1

      set NIX_PATH $HOME/.nix-defexpr/channels $NIX_PATH
      #This checks if we have opam and evals the env if we do. Means we get the autoeval if we do and we can ignore it if we don't
      # if test (which opam)
      #     eval (opam env); or true 
      # end



    '';
    #source /home/eli/.opam/opam-init/init.fish > /dev/null 2> /dev/null; or true
  };
}
