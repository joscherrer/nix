{ self, inputs, outputs, config, pkgs, ... }:
{
  programs.rofi = {
    enable = true;
    package = pkgs.rofi-wayland;
  };

  programs.vscode = {
    enable = true;
    package = pkgs.vscode-fhs;
  };

  programs.firefox.enable = true;
}
