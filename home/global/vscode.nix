{ inputs, lib, pkgs, config, outputs, ... }:
{
  programs.vscode = {
    enable = true;
    mutableExtensionsDir = true;
    enableExtensionUpdateCheck = true;
    enableUpdateCheck = true;
  };

  home.sessionVariables.NIXOS_OZONE_WL = "1";
}
