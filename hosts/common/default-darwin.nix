{ self, inputs, outputs, config, pkgs, ... }:
{
  imports = [
    inputs.home-manager.darwinModules.home-manager
  ];
  nix = {
    gc = {
      automatic = true;
      interval = {
        Weekday = 7;
      };
      options = "--delete-older-than 30d";
    };
  };
}
