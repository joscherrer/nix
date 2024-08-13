{ inputs, outputs, self, ... }:
{
   imports = [
    inputs.nixos-wsl.nixosModules.default
  ];


  wsl = {
    enable = true;
  };

  nixpkgs.config.allowUnfree = true;

  users.users.jscherrer = {
    isNormalUser = true;
    description = "Jonathan Scherrer";
    extraGroups = [ "networkmanager" "wheel" ];
  };

  system.stateVersion = "24.05"; # Did you read the comment?

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    users.jscherrer = import "${self}/home/jscherrer/bbrain-linux.nix";
    users.root = import "${self}/home/root";
    extraSpecialArgs = { inherit inputs outputs; };
  };

  # fonts.packages = [
  #   pkgs.nerdfonts
  # ];

}
