{
  inputs,
  config,
  pkgs,
  lib,
  ...
}:
{
  imports = [
    ../global
    # ../global/gui
  ];

  home.username = lib.mkDefault "jscherrer";
  home.homeDirectory = lib.mkDefault "/home/jscherrer";

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 10d";
  };

  programs.keychain.enable = true;
  services.gnome-keyring.enable = true;
  # security.pam.services = {
  #     sudo_local = {
  #       touchIdAuth = true;
  #     };
  # };

  xdg.mimeApps.enable = true;
  xdg.mimeApps.defaultApplications = {
    "text/html" = "firefox.desktop";
    "x-scheme-handler/http" = "firefox.desktop";
    "x-scheme-handler/https" = "firefox.desktop";
    "x-scheme-handler/about" = "firefox.desktop";
    "x-scheme-handler/unknown" = "firefox.desktop";
  };
  home.packages = [
    pkgs.buildah
    pkgs.unstable.vagrant
    pkgs.obsidian
    # pkgs.yubikey-manager-qt
    pkgs.moonlight-qt
    pkgs.desktop-file-utils
    # pkgs.ankama-launcher
  ];

}
