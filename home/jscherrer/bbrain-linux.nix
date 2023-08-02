{ inputs, config, pkgs, lib, ... }:
{
  imports = [
    ../global
    ../global/gui.nix
  ];

  home.username = lib.mkDefault "jscherrer";
  home.homeDirectory = lib.mkDefault "/home/jscherrer";

  programs.keychain.enable = true;
  services.gnome-keyring.enable = true;
}
