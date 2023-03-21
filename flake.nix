{
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-22.11";
    nixpkgs-unstable.url = "nixpkgs/nixos-unstable";
    hyprland.url = "github:hyprwm/Hyprland";
    home-manager.url = "github:nix-community/home-manager";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, home-manager, ... }@inputs:
    let
      inherit (self) outputs;
      overlay-unstable = final: prev: {
        unstable = nixpkgs-unstable.legacyPackages.${prev.system};
      };
      supportedSystems = [ "x86_64-linux" "aarch64-linux" ];
      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;
    in
    rec {
      nixosModules = import ./modules/nixos;
      homeManagerModules = import ./modules/home-manager;
      overlays = import ./overlays;

      packages = forAllSystems (system:
        import ./pkgs { pkgs = nixpkgs.legacyPackages.${system}; }
      );

      nixosConfigurations = {
        dx15-qemu = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit self inputs outputs; };
          modules = [
            ./hosts/dx15-qemu
          ];
        };

        dx15 = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit self inputs outputs; };
          modules = [
            ./hosts/dx15
          ];
        };
      };

      homeConfigurations = {
        "jscherrer@dx15-qemu" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages."x86_64-linux";
          extraSpecialArgs = { inherit inputs outputs; };
          modules = [
            ./home/jscherrer/dx15-qemu.nix
          ];
        };

        "jscherrer@dx15" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages."x86_64-linux";
          extraSpecialArgs = { inherit inputs outputs; };
          modules = [
            ./home/jscherrer/dx15.nix
          ];
        };
      };
    };
}
