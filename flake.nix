{
  description ="NixOS configuration and home-manager configurations for my desktop and laptop";
  inputs.nixpkgs.url = "nixpkgs/nixos-22.11";
  inputs.nixpkgs-unstable.url = "nixpkgs/nixos-unstable";


  # inputs.nur = {
  #   url = "github:nix-community/NUR";
  #   inputs.nixpkgs.follows = "nixpkgs";
  # };
  inputs.home-manager = {
    url = "github:rycee/home-manager/release-22.11";
    inputs.nixpkgs.follows = "nixpkgs";
  };


  outputs = { home-manager, nixpkgs-unstable, nixpkgs, ... }@inputs:
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
    pkgs = import nixpkgs{
      inherit system;
      config.allowUnfree=true;
    };
    unstable = import nixpkgs-unstable{
      inherit system;
      config.allowUnfree=true;
    };
    in
    {
      # NixOS configuration entrypoint
      # Available through 'nixos-rebuild --flake .#your-hostname'
      nixosConfigurations = {
        laptop = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            ./nixos-config/hosts/laptop/default.nix
          ];
          specialArgs = { inherit inputs pkgs unstable; };
        };
        desktop = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            ./nixos-config/hosts/desktop/default.nix
          ];
          specialArgs = { inherit inputs pkgs unstable; };
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
