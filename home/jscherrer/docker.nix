{
  inputs,
  outputs,
  config,
  pkgs,
  lib,
  ...
}:
{
  imports = [
    ../global/minimal.nix
  ];

  # nixpkgs.overlays = builtins.attrValues outputs.overlays;

  home.username = lib.mkDefault "jscherrer";
  home.homeDirectory = lib.mkDefault "/home/jscherrer";

  programs.keychain.enable = true;
  services.gnome-keyring.enable = true;

  # home.packages = [
  #   pkgs.buildah
  # ];
}
