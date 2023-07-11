{ inputs, lib, pkgs, config, outputs, ... }:
{
  programs.fzf.enable = true;
  programs.fzf.enableZshIntegration = true;
  # programs.fzf.changeDirWidgetCommand = "${pkgs.z-lua}"
  home.packages = with pkgs; [
    z-lua
  ];
}
