{
  inputs = {
    # nixpkgs.url = "nixpkgs/nixos-23.05";
    # nixpkgs-darwin.url = "github:nixos/nixpkgs/nixpkgs-23.05-darwin";

    nixpkgs.url = "nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "nixpkgs/nixos-23.11";
    nixpkgs-darwin.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nixpkgs-darwin-stable.url = "github:nixos/nixpkgs/nixpkgs-23.11-darwin";
    nixpkgs-unstable.url = "nixpkgs/nixos-unstable";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    darwin.url = "github:LnL7/nix-darwin";
    darwin.inputs.nixpkgs.follows = "nixpkgs-darwin";

    kmonad.url = "git+https://github.com/kmonad/kmonad?submodules=1&dir=nix";
    kmonad.inputs.nixpkgs.follows = "nixpkgs";

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    vscode-server.url = "github:nix-community/nixos-vscode-server";

    nil.url = "github:oxalica/nil";
  };

  outputs = { self, nixpkgs, nixpkgs-stable, nixpkgs-unstable, home-manager, darwin, kmonad, nil, ... }@inputs:
    let
      inherit (self) outputs;
      overlay-unstable = final: prev: {
        unstable = import nixpkgs-unstable {
          system = prev.system;
          config.allowUnfree = true;
        };
        # unstable = nixpkgs-unstable.legacyPackages.${prev.system};
      };
      overlay-stable = final: prev: {
        stable = import nixpkgs-stable {
          system = prev.system;
          config.allowUnfree = true;
        };
        # stable = nixpkgs-stable.legacyPackages.${prev.system};
      };
      overlay-kubectx = final: prev: {
        kubectx = prev.kubectx.overrideAttrs (old: {
          postInstall = old.postInstall + ''
            ln -s $out/bin/kubens $out/bin/kubectl-ns
          '';
        });
      };

      overlay-terraform = final: prev: {
        terraform = prev.terraform.overrideAttrs (old: {
          ldflags = old.ldflags ++ [ "-X" "'github.com/hashicorp/terraform/version.dev=no'" ];
        });
      };

      # overlay-pdm = final: prev: {
      #   pdm = prev.pdm.overrideAttrs (old: {
      #     python = (prev.python3.withPackages (ps: with ps; [ virtualenv ]));
      #   });
      # };

      overlay-pdm = final: prev: {
        pdm = prev.pdm.overrideAttrs (old: {
          propagatedBuildInputs = old.propagatedBuildInputs ++ [ prev.python3.pkgs.truststore ];
        });
      };

      overlay-jetbrains = final: prev:
        let
          tools = [ "goland" "idea-ultimate" ];
          makeToolOverlay = tool: {
            ${tool} = prev.jetbrains.${tool}.overrideAttrs (old: {
              patches = (old.patches or [ ]) ++ [
                ./patches/jetbrains/remote-dev-server-fontconfig.patch
              ];
            });
          };
        in
        {
          jetbrains = prev.jetbrains //
            builtins.foldl' (acc: tool: acc // makeToolOverlay tool) { } tools;
        };

      supportedSystems = [ "x86_64-linux" "aarch64-linux" "aarch64-darwin" ];
      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;
      colorlib = import ./colors.nix nixpkgs.lib;
    in
    rec {
      nixosModules = import ./modules/nixos;
      homeManagerModules = import ./modules/home-manager;
      overlays = import ./overlays // {
        unstable = overlay-unstable;
        stable = overlay-stable;
        inherit overlay-kubectx;
        inherit overlay-terraform;
        # inherit overlay-jetbrains;
        inherit overlay-pdm;
      };

      packages = forAllSystems (system:
        import ./pkgs {
          pkgs = nixpkgs.legacyPackages.${system};
        }
      );

      nixosConfigurations = {
        bbrain-linux = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = {
            default = import ./lib/theme { inherit colorlib; lib = nixpkgs.lib; };
            inherit self inputs outputs;
          };
          modules = [
            ./hosts/bbrain-linux
          ];
        };
        jo-home = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = {
            default = import ./lib/theme { inherit colorlib; lib = nixpkgs.lib; };
            inherit self inputs outputs;
          };
          modules = [
            ./hosts/jo-home
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
