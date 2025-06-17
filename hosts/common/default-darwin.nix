{ self, inputs, outputs, config, pkgs, ... }:
{
  imports = [
    inputs.home-manager.darwinModules.home-manager
  ];
}
