{
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-22.11";
    hyprland.url = "github:hyprwm/Hyprland";
  };

  outputs = { self, nixpkgs, hyprland, ... }@inputs:
    let
      inherit (self) outputs;
    in
    rec {
      nixosConfigurations = {
        dx15-qemu = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs outputs; };
          modules = [
            ./hosts/dx15-qemu/configuration.nix
          ];
        };
      };
    };
}
