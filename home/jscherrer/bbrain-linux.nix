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
    frequency = "hourly";
    options = "--delete-older-than 10d";
  };

  programs.keychain.enable = true;
  services.gnome-keyring.enable = true;
  security.pam.services = {
      sudo_local = {
        touchIdAuth = true;
      };
  };

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
