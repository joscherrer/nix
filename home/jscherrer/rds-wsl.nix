{ inputs, config, pkgs, lib, ... }:
{
  imports = [
    ../global
  ];

  home.username = lib.mkDefault "jscherrer";
  home.homeDirectory = lib.mkDefault "/Users/jscherrer";
  home.stateVersion = "24.05";

  programs.lsd.enable = true;
}
