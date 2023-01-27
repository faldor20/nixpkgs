{
  description =
    "NixOS configuration and home-manager configurations for my desktop and laptop";
  inputs.nixpkgs.url = "nixpkgs/nixos-22.05";
  inputs.unstable.url = "nixpkgs/nixos-unstable";

  # inputs.nur = {
  #   url = "github:nix-community/NUR";
  #   inputs.nixpkgs.follows = "nixpkgs";
  # };
  inputs.home-manager = {
    url = "github:rycee/home-manager/release-22.05";
    inputs.nixpkgs.follows = "nixpkgs";
  };


  outputs = { home-manager, unstable,  nixos-hardware, nixpkgs, ... }:
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
      nixpkgs-config = {
        unstable.config = {
          # Needed for Slack
          allowUnfree = true;

          allowUnfreePredicate = (pkg: true);

        };
        nixpkgs.config = {
          # Needed for Slack
          allowUnfree = true;

          allowUnfreePredicate = (pkg: true);

        };
      };
    in
    {
      #"laptop" = home-manager.lib.homeManagerConfiguration {
      #   configuration = homeManagerConfFor ./hosts/t14-debian/home.nix;
      #   system = "x86_64-linux";
      #   homeDirectory = "/home/sebastian";
      #   username = "sebastian";
      #   stateVersion = "21.05";
      # };
      nixosConfigurations.laptop = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          nixpkgs-config
          ./nixos-config/hosts/laptop/default.nix
          home-manager.nixosModules.home-manager
          {
            home-manager.useUserPackages = true;
            home-manager.users.eli = import ./home-manager/hosts/laptop/default.nix;
            home-manager.extraSpecialArgs = { inherit unstable; };

          }
        ];
        specialArgs = { inherit nixpkgs unstable; };
      };

      nixosConfigurations.desktop = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./nixos-config/hosts/desktop/default.nix
          home-manager.nixosModules.home-manager
          {
            home-manager.useUserPackages = true;
            home-manager.users.eli = import ./home-manager/hosts/laptop/default.nix;
            home-manager.extraSpecialArgs = { inherit nixpkgs unstable; };
          }
        ];
        specialArgs = { inherit nixpkgs unstable; };
      };

    };
}
