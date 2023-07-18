{ inputs, lib, pkgs, config, outputs, ... }:
let
  common-root = "${inputs.self}/dotfiles/common";
in
{
  home.file.".config/hypr/hyprland.conf".source = "${common-root}/.config/hypr/hyprland.conf";
}
