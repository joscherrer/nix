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

  wayland.windowManager.hyprland = {
    settings = {
      monitor = [
        "desc:Acer Technologies V277 E 842614EC23W01,1920x1080@100,1080x160,1"
        "desc:Acer Technologies V277 E 842614D663W01,1920x1080@100,0x0,auto,transform,1"
      ];
      workspace = [
        "1, monitor:desc:Acer Technologies V277 E 842614EC23W01, persistent:true, default:true"
        "2, monitor:desc:Acer Technologies V277 E 842614D663W01, persistent:true, default:true, layoutopt:orientation:top"
        "3, monitor:desc:Acer Technologies V277 E 842614EC23W01, persistent:true, default:false"
        "4, monitor:desc:Acer Technologies V277 E 842614D663W01, persistent:true, default:false, layoutopt:orientation:top"
        "5, monitor:desc:Acer Technologies V277 E 842614EC23W01, persistent:true, default:false"
        "6, monitor:desc:Acer Technologies V277 E 842614D663W01, persistent:true, default:false, layoutopt:orientation:top"
        "7, monitor:desc:Acer Technologies V277 E 842614EC23W01, persistent:true, default:false"
        "8, monitor:desc:Acer Technologies V277 E 842614D663W01, persistent:true, default:false, layoutopt:orientation:top"
        "9, monitor:desc:Acer Technologies V277 E 842614EC23W01, persistent:true, default:false"
        "10, monitor:desc:Acer Technologies V277 E 842614D663W01, persistent:true, default:false, layoutopt:orientation:top"
        "11, monitor:desc:AOC 28E850, persistent:true, default:true"
      ];
    };
  };

}
