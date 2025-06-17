{
  self,
  inputs,
  outputs,
  config,
  pkgs,
  ...
}:
{
  imports = [
    inputs.home-manager.nixosModules.home-manager
  ];

  home-manager = {
    useUserPackages = true;
    users.jscherrer = import "${self}/home/jscherrer/${config.networking.hostName}.nix";
    extraSpecialArgs = { inherit inputs outputs; };
  };
}

