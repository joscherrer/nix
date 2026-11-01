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
    ../global/gui
  ];

  home.username = lib.mkDefault "jscherrer";
  home.homeDirectory = lib.mkDefault "/home/jscherrer";

  # programs.keychain.enable = true;
  # services.gnome-keyring.enable = true;
  # security.pam.services = {
  #     login.u2fAuth = true;
  #     sudo.u2fAuth = true;
  # };

  programs.git = {
    userEmail = "jonathan@jumbomana.com";
  };

  xdg.mimeApps.enable = true;
  xdg.mimeApps.defaultApplications = {
    "text/html" = "firefox.desktop";
    "x-scheme-handler/http" = "firefox.desktop";
    "x-scheme-handler/https" = "firefox.desktop";
    "x-scheme-handler/about" = "firefox.desktop";
    "x-scheme-handler/unknown" = "firefox.desktop";
  };
  home.packages = [
    #pkgs.kanshi
    #pkgs.buildah
    #pkgs.pdm
    #pkgs.vagrant
    pkgs.obsidian
    #pkgs.yubikey-manager-qt
    # pkgs.ankama-launcher
  ];

  # Monitor layout + workspace sets, shared with the greeter (see
  # dotfiles/common/.config/hypr/base/monitors.lua).
  wayland.windowManager.hyprland.extraLuaFiles.host = {
    autoLoad = false;
    content = builtins.readFile ../../dotfiles/hosts/jumbo/hypr/host.lua;
  };

}
