{ inputs, config, pkgs, lib, ... }:
{
  imports = [
    ../global
    ../global/gui/terminal.nix
  ];

  home.username = lib.mkDefault "jscherrer";
  home.homeDirectory = lib.mkDefault "/Users/jscherrer";
  home.stateVersion = "22.11";

  home.packages = with pkgs; [
    # Others
    # unstable.mitmproxy
    wireshark
    # youtube-dl
    # inputs.kmonad.packages."${pkgs.system}".kmonad
  ];

  programs.lsd.enable = true;
}
