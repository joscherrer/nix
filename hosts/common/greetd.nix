{ inputs, outputs, config, pkgs, ... }:
let
  cage-kiosk = pkgs.writeShellScriptBin "cage-kiosk" ''
    dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP
    exec ${pkgs.cage}/bin/cage -s -- ${pkgs.greetd.gtkgreet}/bin/gtkgreet -l -s /etc/greetd/gtkgreet.css
  '';

  hyprland-kiosk = pkgs.writeShellScriptBin "hyprland-kiosk" ''
    export XDG_SESSION_TYPE=wayland
    export HYPRLAND_LOG_WLR=1
    export XCURSOR_THEME=Bibata-Modern-Classic
    export XCURSOR_SIZE=24
    # export GTK_IM_MODULE=fcitx
    # export QT_IM_MODULE=fcitx
    # export XMODIFIERS=@im=fcitx
    # export SDL_IM_MODULE=fcitx
    # export GLFW_IM_MODULE=ibus

    dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP
    exec ${config.programs.hyprland.package}/bin/Hyprland --config /etc/greetd/hyprland.conf
  '';
in
{
  services.logind = {
    lidSwitch = "suspend";
    lidSwitchExternalPower = "lock";
  };

  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${hyprland-kiosk}/bin/hyprland-kiosk";
        user = "greeter";
      };
    };
  };
  programs.regreet.enable = true;

  environment.systemPackages = [
    cage-kiosk
    hyprland-kiosk
    pkgs.greetd.gtkgreet
    pkgs.cage
    # pkgs.qt6.qtwayland
  ];

  environment.etc."greetd/environments".text = "zsh";
  environment.etc."greetd/gtkgreet.css".text = ''
    window {
        background-color: black;
        color: white;
    }
  '';
  # environment.etc."greetd/hyprland.conf".text = ''
  #   source = /etc/hypr/default.conf
  #   exec = systemd-cat --identifier=gtkgreet ${pkgs.greetd.gtkgreet}/bin/gtkgreet -l -s /etc/greetd/gtkgreet.css; hyprctl dispatch exit ""
  # '';
  environment.etc."greetd/hyprland.conf".text = ''
    source = /etc/hypr/default.conf
    exec-once=dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP
    exec = systemd-cat --identifier=regreet ${pkgs.greetd.regreet}/bin/regreet; hyprctl dispatch exit ""
  '';
}

