{
  description = "A flake to build and distribute a Go program";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs =
    inputs@{ self, nixpkgs, ... }:
    let
      inherit (nixpkgs) lib;
      # List the systems you want to support
      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];
      eachSystem = lib.genAttrs systems;
      # Utility to create pkgs for each system
      pkgsFor = eachSystem (
        system:
        import nixpkgs {
          system = system;
        }
      );
      pname = "hyprfollow"; # CHANGE THIS to your binary name
      version = "0.1.0"; # CHANGE THIS to your version
    in
    {
      packages = eachSystem (system: {
        # Main Go binary package
        ${pname} = pkgsFor.${system}.buildGoModule {
          inherit pname version;
          src = ./.;
          vendorHash = null; # Replace with hash after first build
        };
        default = self.packages.${system}.${pname};
      });

      apps = eachSystem (system: {
        ${pname} = {
          type = "app";
          program = "${self.packages.${system}.${pname}}/bin/${pname}";
        };
        default = self.apps.${system}.${pname};
      });

      # Optionally, a devShell for development
      devShells = eachSystem (system: {
        default = pkgsFor.${system}.mkShell {
          buildInputs = [
            pkgsFor.${system}.go
            pkgsFor.${system}.gotools
          ];
        };
      });
    };
}
