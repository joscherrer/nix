{ inputs, config, pkgs, lib, ... }:
{
  programs.kitty = {
    enable = true;
    theme = "Snazzy";
    font.name = "CaskaydiaCove Nerd Font";
    font.size = 15;
  };
}
