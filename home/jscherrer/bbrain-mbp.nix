{ inputs, config, pkgs, lib, ... }:
{
  imports = [
    ../global
    ../../modules/alacritty
  ];

  home.username = lib.mkDefault "jscherrer";
  home.homeDirectory = lib.mkDefault "/Users/jscherrer";
  home.stateVersion = "22.11";

  home.packages = with pkgs; [
    # Others
    unstable.mitmproxy
    wireshark
    youtube-dl
    inputs.kmonad.packages."${pkgs.system}".kmonad
  ];

  programs.alacritty.settings = {
    font.normal.family = "CaskaydiaCove Nerd Font Mono";
    font.bold.family = "CaskaydiaCove Nerd Font Mono";
    font.italic.family = "CaskaydiaCove Nerd Font Mono";
    font.bold_italic.family = "CaskaydiaCove Nerd Font Mono";
  };

  programs.lsd.enable = true;
}
