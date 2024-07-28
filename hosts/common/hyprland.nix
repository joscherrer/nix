{ self, inputs, outputs, config, pkgs, lib, ... }:
let
  hyprland-wrapper = pkgs.writeShellScriptBin "hyprland" ''
    # XDG
    export XDG_CURRENT_DESKTOP=Hyprland
    export XDG_SESSION_DESKTOP=Hyprland
    export XDG_SESSION_TYPE=wayland

    # QT
    export QT_AUTO_SCREEN_SCALE_FACTOR=1
    export QT_QPA_PLATFORM="wayland;xcb"
    export QT_WAYLAND_DISABLE_WINDOWDECORATION=1
    # QT_QPA_PLATFORMTHEME=qt5ct

    # Hyprland
    export HYPRLAND_LOG_WLR=1

    # Cursor  
    export XCURSOR_THEME=Bibata-Modern-Classic
    export XCURSOR_SIZE=24

    # IM
    export QT_IM_MODULE=ibus
    export SDL_IM_MODULE=ibus
    export GTK_IM_MODULE=ibus
    export GLFW_IM_MODULE=ibus
    export XMODIFIERS=""

    # Misc
    export GBM_BACKEND=nvidia-drm
    export __GLX_VENDOR_LIBRARY_NAME=nvidia
    export WLR_NO_HARDWARE_CURSORS=1

    cd ~ && exec systemd-cat --identifier=Hyprland ${config.programs.hyprland.package}/bin/Hyprland "$@"
  '';

  hyprland-log = pkgs.writeTextFile {
    name = "hyprland-log";
    destination = "/share/wayland-sessions/hyprland-log.desktop";
    text = ''
      [Desktop Entry]
      Name=Hyprland Log
      Comment=An intelligent dynamic tiling Wayland compositor
      Exec=${hyprland-wrapper}/bin/hyprland
      Type=Application
    '';
  } // {
    providedSessions = ["hyprland-log"];
  };
in
{
  imports = [
    ./greetd.nix
  ];

  nix.settings = {
    substituters = ["https://hyprland.cachix.org"];
    trusted-public-keys = ["hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="];
  };

  programs = {
    hyprland = {
      enable = true;
      xwayland = {
        enable = true;
      };
    };
  };

  # Workaround waiting for upstream fix :
  # https://github.com/hyprwm/Hyprland/issues/661
  systemd.tmpfiles.rules = [
    "d /tmp/hypr 777"
  ];

  environment.systemPackages = [
    hyprland-wrapper
    pkgs.wayvnc
    hyprland-log
  ];

  services.displayManager.sessionPackages = [ hyprland-log ];

  environment.etc."greetd/environments".text = "hyprland";
  environment.etc."hypr/default.conf".text = ''
    monitor=desc:LG Electronics LG HDR WQHD+ 205NTCZ8L675,3840x1600@144,1920x0,auto
    monitor=desc:Dell Inc. DELL U2415 7MT0167B2YNL,disable
    monitor=desc:AOC 28E850,disable
  
    $mainMod=SUPER
    bind=$mainMod, M, exit,
    misc {
      disable_hyprland_logo = true
    }

    input {
      kb_layout = us(intl),fr(azerty)
      kb_options = grp:alt_space_toggle
    }
  '';
}
