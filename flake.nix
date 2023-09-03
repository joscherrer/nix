{
  inputs = {
    # nixpkgs.url = "nixpkgs/nixos-23.05";
    # nixpkgs-darwin.url = "github:nixos/nixpkgs/nixpkgs-23.05-darwin";
  
    nixpkgs.url = "nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "nixpkgs/nixos-23.05";
    nixpkgs-darwin.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nixpkgs-darwin-stable.url = "github:nixos/nixpkgs/nixpkgs-23.05-darwin";
    nixpkgs-unstable.url = "nixpkgs/nixos-unstable";
    hyprland.url = "github:hyprwm/Hyprland";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    darwin.url = "github:LnL7/nix-darwin";
    darwin.inputs.nixpkgs.follows = "nixpkgs-darwin";

    kmonad.url = "git+https://github.com/kmonad/kmonad?submodules=1&dir=nix";
    kmonad.inputs.nixpkgs.follows = "nixpkgs";

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    vscode-server.url = "github:nix-community/nixos-vscode-server";
  };

  outputs = { self, nixpkgs, nixpkgs-stable, nixpkgs-unstable, home-manager, darwin, kmonad, ... }@inputs:
    let
      inherit (self) outputs;
      overlay-unstable = final: prev: {
        unstable = nixpkgs-unstable.legacyPackages.${prev.system};
      };
      overlay-stable = final: prev: {
        stable = nixpkgs-stable.legacyPackages.${prev.system};
      };
      overlay-kubectx = final: prev: {
        kubectx = prev.kubectx.overrideAttrs (old: {
          postInstall = old.postInstall + ''
            ln -s $out/bin/kubens $out/bin/kubectl-ns
          '';
        });
      };
      supportedSystems = [ "x86_64-linux" "aarch64-linux" "aarch64-darwin" ];
      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;
    in
    rec {
      nixosModules = import ./modules/nixos;
      homeManagerModules = import ./modules/home-manager;
      overlays = import ./overlays // {
        unstable = overlay-unstable;
        stable = overlay-stable;
        inherit overlay-kubectx;
      };

      packages = forAllSystems (system:
        import ./pkgs {
          pkgs = nixpkgs.legacyPackages.${system};
        }
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

        bbrain-linux = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit self inputs outputs; };
          modules = [
            ./hosts/bbrain-linux
          ];
        };
      };

      darwinConfigurations = {
        bbrain-mbp = darwin.lib.darwinSystem {
          system = "aarch64-darwin";
          specialArgs = { inherit self inputs outputs; };
          modules = [
            ./hosts/bbrain-mbp
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
