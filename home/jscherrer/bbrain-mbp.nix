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
    font.normal.family = "JetBrainsMono Nerd Font";
    font.bold.family = "JetBrainsMono Nerd Font";
    font.italic.family = "JetBrainsMono Nerd Font";
    font.bold_italic.family = "JetBrainsMono Nerd Font";
  };

  programs.lsd.enable = true;
}
