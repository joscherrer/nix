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

  programs.keychain.enable = true;
  services.gnome-keyring.enable = true;
  # security.pam.services = {
  #     login.u2fAuth = true;
  #     sudo.u2fAuth = true;
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
    pkgs.kanshi
    pkgs.buildah
    pkgs.pdm
    pkgs.poetry
    pkgs.stable.vagrant
    pkgs.obsidian
    pkgs.yubikey-manager-qt
    pkgs.stockfish
    # pkgs.ankama-launcher
  ];

  wayland.windowManager.hyprland = {
    settings = {
      workspace = [
        "1, monitor:desc:LG Electronics LG HDR WQHD+ 205NTCZ8L675, persistent:true, default:true"
        "2, monitor:desc:Dell Inc. DELL U2415 7MT0167B2YNL, persistent:true, default:true, layoutopt:orientation:top"
        "3, monitor:desc:LG Electronics LG HDR WQHD+ 205NTCZ8L675, persistent:true, default:false"
        "4, monitor:desc:Dell Inc. DELL U2415 7MT0167B2YNL, persistent:true, default:false, layoutopt:orientation:top"
        "5, monitor:desc:LG Electronics LG HDR WQHD+ 205NTCZ8L675, persistent:true, default:false"
        "6, monitor:desc:Dell Inc. DELL U2415 7MT0167B2YNL, persistent:true, default:false, layoutopt:orientation:top"
        "7, monitor:desc:LG Electronics LG HDR WQHD+ 205NTCZ8L675, persistent:true, default:false"
        "8, monitor:desc:Dell Inc. DELL U2415 7MT0167B2YNL, persistent:true, default:false, layoutopt:orientation:top"
        "9, monitor:desc:LG Electronics LG HDR WQHD+ 205NTCZ8L675, persistent:true, default:false"
        "10, monitor:desc:Dell Inc. DELL U2415 7MT0167B2YNL, persistent:true, default:false, layoutopt:orientation:top"
        "11, monitor:desc:AOC 28E850, persistent:true, default:true"
      ];
    };
  };

}
