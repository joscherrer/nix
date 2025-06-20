{
  inputs,
  outputs,
  self,
  ...
}:
{
  imports = [
    inputs.nixos-wsl.nixosModules.default
  ];

  wsl = {
    enable = true;
    defaultUser = "jscherrer";
  };

  users.users.jscherrer = {
    isNormalUser = true;
    description = "Jonathan Scherrer";
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
  };

  system.stateVersion = "24.05"; # Did you read the comment?

  home-manager = {
    useUserPackages = true;
    users.jscherrer = import "${self}/home/jscherrer/jo-home.nix";
    users.root = import "${self}/home/root";
    extraSpecialArgs = { inherit inputs outputs; };
  };

  # fonts.packages = [
  #   pkgs.nerdfonts
  # ];

}
