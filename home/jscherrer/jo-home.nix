{ inputs, config, pkgs, lib, ... }:
{
  imports = [
    ../global
  ];

  home.username = lib.mkDefault "jscherrer";
  home.homeDirectory = lib.mkDefault "/Users/jscherrer";
  home.stateVersion = "24.05";

  programs.alacritty.settings = {
    font.normal.family = "JetBrainsMono Nerd Font";
    font.bold.family = "JetBrainsMono Nerd Font";
    font.italic.family = "JetBrainsMono Nerd Font";
    font.bold_italic.family = "JetBrainsMono Nerd Font";
  };

  programs.lsd.enable = true;
}
