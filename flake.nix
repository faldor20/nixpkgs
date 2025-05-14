{
  description = "NixOS configuration and home-manager configurations for my desktop and laptop";

  nixConfig = {
    extra-substituters = [ "https://nix-community.cachix.org" ];
    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-24.05";
    nixpkgs-unstable.url = "nixpkgs/nixos-unstable";



    helix.url = "github:clo4/helix/helix-cogs-steel-language-server";
    helix.inputs.nixpkgs.follows = "nixpkgs-unstable";
    helix.inputs.crane.follows = "crane";
    crane.url = "github:ipetkov/crane";
    steel.url = "github:mattwparas/steel";
    steel.inputs.nixpkgs.follows = "nixpkgs-unstable";

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    # neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";
    # inputs.nur = {
    #   url = "github:nix-community/NUR";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };
    home-manager = {
      url = "github:rycee/home-manager/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      home-manager,
      nixpkgs-unstable,
      nixpkgs,
      helix,
      nixos-hardware,
      steel,
      ...
    }@inputs:
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
      steel-pkg = steel.packages.${system}.steel.overrideAttrs (oldAttrs: {
        cargoBuildFlags = "-p cargo-steel-lib -p steel-interpreter -p steel-language-server";
      });
      #We import the packages to make them useable by home manager and the like and also enable using unfree packages
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
        #We add this helix overlay to nixpkgs which means we will now use the helix editor from master

        overlays = [
          # helix.overlays.default
          (self: super: {
            helix-cogs = helix.packages.${system}.helix-cogs;
            helix = helix.packages.${system}.helix;
            steel-pkg = steel-pkg;
          })
          (self: super: { windsurf = (self.callPackage ./pkgs/windsurf.nix { inherit nixpkgs; }); })

        ];
      };
      unstable = import nixpkgs-unstable {
        inherit system;
        config.allowUnfree = true;

        #for obsidian
        config.permittedInsecurePackages = [ "electron-27.3.11" ];
        overlays=[
          (self: super:{
            # zed-editor-new=super.zed-editor.override(
            # let
            #     rp = super.rustPlatform;
            #     v="0.175.1-pre";
            #     in
            # {
            #     rustPlatform = rp // {
            #       buildRustPackage = args: rp.buildRustPackage (
            #         args // rec {
            #           # Here's where we can toy with the inputs
            #           version = v;
            #           src = super.fetchFromGitHub {
            #                   owner = "zed-industries";
            #                   repo = "zed";
            #                   rev = "v${v}";
            #                   hash = "sha256-+R6XuA2k93Av4zoaYHgcRnz472mNUXBEnW9z9z1qE0Y=";  # Use the hash provided in the first error
            #             };
            #           cargoHash = "sha256-yhq6h4dq+jg/fxgB3M/sODLNutUbx8nXRX9kps7rhFE=";
            #         }
            #       );
                # };
              # });
              })
        ];

      };

    in
    {
      # this makes `nix shell` commands use the system version of nixpkgs by default
      nix.registry.nixpkgs.flake = inputs.nixpkgs;
      nix.registry.unstable.flake = inputs.nixpkgs-unstable;
      # NixOS configuration entrypoint
      # Available through 'nixos-rebuild --flake .#your-hostname'
      nixosConfigurations = {
        laptop = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            ./nixos-config/hosts/laptop/default.nix
            # stylix.nixosModules.stylix
          ];
          specialArgs = {
            inherit
              nixpkgs
              nixpkgs-unstable
              inputs
              pkgs
              unstable
              ;
          };
        };
        xps13 = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            nixos-hardware.nixosModules.dell-xps-13-9310
            ./nixos-config/hosts/xps13/default.nix
          ];
          specialArgs = {
            inherit
              nixpkgs
              nixpkgs-unstable
              inputs
              pkgs
              unstable
              ;
          };
        };
        desktop = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [ ./nixos-config/hosts/desktop/default.nix ];
          specialArgs = {
            inherit
              nixpkgs
              nixpkgs-unstable
              inputs
              pkgs
              unstable
              ;
          };
        };
      };

      # Standalone home-manager configuration entrypoint
      # Available through 'home-manager --flake .#your-username@your-hostname'
      homeConfigurations = {

        # FIXME replace with your username@hostname
        "eli@desktop" = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          extraSpecialArgs = {
            inherit inputs unstable;
          }; # Pass flake inputs to our config
          # > Our main home-manager configuration file <
          modules = [
            ./home-manager/hosts/desktop/default.nix
            { }
          ];
        };
        "eli@laptop" = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          extraSpecialArgs = {
            inherit inputs unstable;
          }; # Pass flake inputs to our config
          # > Our main home-manager configuration file <
          modules = [
            ./home-manager/hosts/laptop/default.nix
            { }
          ];
        };

      };

    };
}
