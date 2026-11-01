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

  systemd.user.services."nvim-server" = {
    Unit = {
      Description = "Neovim server";
      After = [ "network.target" ];
    };
    Service = {
      Type = "simple";
      ExecStart = "${pkgs.neovim}/bin/nvim --headless --listen 0.0.0.0:6666 --cmd 'let g:neovide = v:true'";
      Restart = "always";
    };
  };

  systemd.user.services."nvim-server-2" = {
    Unit = {
      Description = "Neovim server";
      After = [ "network.target" ];
    };
    Service = {
      Type = "simple";
      ExecStart = "${pkgs.neovim}/bin/nvim --headless --listen 0.0.0.0:6667 --cmd 'let g:neovide = v:true'";
      Restart = "always";
    };
  };

  systemd.user.services."nvim-server-3" = {
    Unit = {
      Description = "Neovim server";
      After = [ "network.target" ];
    };
    Service = {
      Type = "simple";
      ExecStart = "${pkgs.neovim}/bin/nvim --headless --listen 0.0.0.0:6668 --cmd 'let g:neovide = v:true'";
      Restart = "always";
    };
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
    pkgs.kanshi
    pkgs.buildah
    pkgs.pdm
    pkgs.poetry
    pkgs.unstable.vagrant
    pkgs.obsidian
    # pkgs.yubikey-manager-qt
    pkgs.stockfish
    pkgs.moonlight-qt
    pkgs.desktop-file-utils
    # pkgs.ankama-launcher
    pkgs.steam
  ];

  # Monitor layout + workspace sets, shared with the greeter (see
  # dotfiles/common/.config/hypr/base/monitors.lua).
  wayland.windowManager.hyprland.extraLuaFiles.host = {
    autoLoad = false;
    content = builtins.readFile ../../dotfiles/hosts/bbrain-linux/hypr/host.lua;
  };

}
