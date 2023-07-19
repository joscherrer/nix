{ self, inputs, outputs, config, pkgs, ... }:
{
  imports = [
    inputs.vscode-server.nixosModules.default
  ];

  services.vscode-server.enable = true;
}