{
  inputs,
  lib,
  pkgs,
  config,
  outputs,
  ...
}:
{
  programs.vscode = {
    enable = true;
    package = pkgs.vscode;
    mutableExtensionsDir = true;
    profiles.default = {
      enableUpdateCheck = true;
      enableExtensionUpdateCheck = true;
    };
  };

  home.sessionVariables.NIXOS_OZONE_WL = "1";
}
