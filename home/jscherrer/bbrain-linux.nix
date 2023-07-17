{ inputs, config, pkgs, lib, ... }:
{
  imports = [
    ../global
    ../../modules/alacritty
  ];

  home.username = lib.mkDefault "jscherrer";
  home.homeDirectory = lib.mkDefault "/home/jscherrer";
}
