{ inputs, config, pkgs, lib, ... }:
{
  imports = [
    ../global
    ../../modules/alacritty
    ../global/gui.nix
  ];

  home.username = lib.mkDefault "jscherrer";
  home.homeDirectory = lib.mkDefault "/home/jscherrer";
}
