{ self, inputs, outputs, config, pkgs, ... }:
{
  imports = [
    ../../modules/alacritty
    ./hyprland.nix
    ./rofi.nix
  ];


  programs.vscode = {
    enable = true;
    package = pkgs.vscode-fhs;
  };

  programs.firefox.enable = true;
}
