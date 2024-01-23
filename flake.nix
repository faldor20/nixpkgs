{
  description ="NixOS configuration and home-manager configurations for my desktop and laptop";
  inputs.nixpkgs.url = "nixpkgs/nixos-23.05";
  inputs.nixpkgs-unstable.url = "nixpkgs/nixos-unstable";
  inputs.helix-editor={
    url = "github:helix-editor/helix";
    inputs.nixpkgs.follows = "nixpkgs";
    };


  # inputs.nur = {
  #   url = "github:nix-community/NUR";
  #   inputs.nixpkgs.follows = "nixpkgs";
  # };
  inputs.home-manager = {
    url = "github:rycee/home-manager/release-23.05";
    inputs.nixpkgs.follows = "nixpkgs";
  };


  outputs = { home-manager, nixpkgs-unstable, nixpkgs, helix-editor,... }@inputs:
    #   { ... }: {
    #     nixpkgs.overlays = [
    #       nur.overlay
    #     ];
    #     imports = [ config ];
    #   };
    # # darwinSystem = darwin.lib.darwinSystem {
    # #   system = "x86_64-darwin";
    # #   modules = [
    # #     ./hosts/macbook/darwin-configuration.nix
    # #     home-manager.darwinModules.home-manager
    # #     {
    # #       home-manager.users.sebastian =
    # #         homeManagerConfFor ./hosts/macbook/home.nix;
    # #     }
    # #   ];
    # #   specialArgs = { inherit nixpkgs; };
    # # };
    # debianSystem = home-manager.lib.homeManagerConfiguration {
    #   configuration = homeManagerConfFor ./hosts/t14-debian/home.nix;
    #   system = "x86_64-linux";
    #   homeDirectory = "/home/sebastian";
    #   username = "sebastian";
    #   stateVersion = "21.05";
    # };
    let
          system = "x86_64-linux";
    #We import the packages to make them useable by home manager and the like and also enable using unfree packages
    pkgs = import nixpkgs {
      inherit system ;
      config.allowUnfree=true;
        #We add this helix overlay to nixpkgs which means we will now use the helix editor from master
      overlays=[helix-editor.overlays.default];
    };
    unstable = import nixpkgs-unstable{
      inherit system;
      config.allowUnfree=true;
    };
    
    in
    {
      # this makes `nix shell` commands use the system version of nixpkgs by default
     nix.registry.nixpkgs.flake = inputs.nixpkgs;
     nix.registry.nixpkgs-unstable.flake = inputs.nixpkgs-unstable;
      # NixOS configuration entrypoint
      # Available through 'nixos-rebuild --flake .#your-hostname'
      nixosConfigurations = {
        laptop = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            ./nixos-config/hosts/laptop/default.nix
          ];
          specialArgs = { inherit nixpkgs inputs pkgs unstable; };
        }; 
		xps13 = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            ./nixos-config/hosts/xps13/default.nix
          ];
          specialArgs = { inherit nixpkgs inputs pkgs unstable; };
        };
        desktop = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            ./nixos-config/hosts/desktop/default.nix
          ];
          specialArgs = { inherit nixpkgs inputs pkgs unstable; };
        };
      };

      # Standalone home-manager configuration entrypoint
      # Available through 'home-manager --flake .#your-username@your-hostname'
      homeConfigurations = {

        # FIXME replace with your username@hostname
        "eli@desktop" = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          extraSpecialArgs = { inherit inputs unstable; }; # Pass flake inputs to our config
          # > Our main home-manager configuration file <
          modules = [
            ./home-manager/hosts/desktop/default.nix
            {
            }
          ];
        };
        "eli@laptop" = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          extraSpecialArgs = { inherit inputs unstable; }; # Pass flake inputs to our config
          # > Our main home-manager configuration file <
          modules = [
            ./home-manager/hosts/laptop/default.nix
            {
            }
          ];
        };

      };


    };
}
