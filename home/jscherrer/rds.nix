{
  inputs,
  config,
  pkgs,
  lib,
  ...
}:
let
  # ilyama = "desc:Iiyama North America PL2474H 1166810210132";
  # mon1 = ilyama;
  mon1 = "eDP-1";
  mon2 = "desc:Lenovo Group Limited L27qe UTP02GR4";
  mon3 = "desc:Lenovo Group Limited L27qe UTP02GR9";

  browser = "google-chrome.desktop";

  start-kitty-dropdown = ''hyprctl clients -j | jq -e '.[] | select(.class == "kitty-dropdown")' || kitty --app-id kitty-dropdown'';
  move-kitty-dropdown = ''hyprctl dispatch movetoworkspace special:terminal,class:kitty-dropdown'';
  toggle-browser = '''';
in
{
  imports = [
    ../global
    ../global/gui
  ];

  home.username = lib.mkDefault "jscherrer";
  home.homeDirectory = lib.mkDefault "/home/jscherrer";

  # services.gnome-keyring = {
  #   enable = true;
  #   components = [
  #     "secrets"
  #     "ssh"
  #     "pkcs11"
  #   ];
  # };

  # programs.keychain.enable = true;
  # security.pam.services = {
  #     login.u2fAuth = true;
  #     sudo.u2fAuth = true;
  # };

  services.ssh-agent = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.git = {
    userEmail = "jonathan.scherrer@rdsdiag.com";
  };

  xdg.mimeApps.enable = true;
  xdg.mimeApps.defaultApplications = {
    "x-scheme-handler/chrome" = [ "${browser}" ];
    "application/x-extension-htm" = "${browser}";
    "application/x-extension-html" = "${browser}";
    "application/x-extension-shtml" = "${browser}";
    "application/x-extension-xht" = "${browser}";
    "application/x-extension-xhtml" = "${browser}";
    "application/xhtml+xml" = "${browser}";
    "x-scheme-handler/ftp" = "${browser}";
    "application/json" = "${browser}";
    "text/html" = "${browser}";
    "x-scheme-handler/http" = "${browser}";
    "x-scheme-handler/https" = "${browser}";
    "x-scheme-handler/about" = "${browser}";
    "x-scheme-handler/unknown" = "${browser}";
  };
  home.packages = [
    #pkgs.kanshi
    #pkgs.buildah
    #pkgs.pdm
    #pkgs.vagrant
    #pkgs.yubikey-manager-qt
    pkgs.obsidian
    pkgs.brightnessctl
    inputs.zen-browser.packages.${pkgs.system}.default
  ];

  # home.sessionVariables = {
  #   BROWSER = lib.mkForce "${inputs.zen-browser.packages.${pkgs.system}.default}/bin/zen";
  #   DEFAULT_BROWSER = lib.mkForce "${inputs.zen-browser.packages.${pkgs.system}.default}/bin/zen";
  # };

  programs.waybar.settings.mainBar = {
    modules-right = lib.mkForce [
      "tray"
      "custom/lock"
      "pulseaudio"
      "battery"
      "clock"
    ];
  };

  services.hyprfollow.enable = lib.mkForce false;

  wayland.windowManager.hyprland = {
    settings = {
      exec-once = [
        ''systemd-inhibit --who="Hyprland config" --why="wlogout keybind" --what=handle-power-key --mode=block sleep infinity & echo $! > /tmp/.hyprland-systemd-inhibit''
      ];

      exec-shutdown = [
        ''kill -9 "$(cat /tmp/.hyprland-systemd-inhibit)"''
      ];

      bind = [
        ",XF86PowerOff, exec, systemctl suspend"
      ];

      bindl = [
        ",switch:on:Lid Switch, exec, hyprctl keyword monitor 'eDP-1, disable' && brightnessctl set 0% --device='tpacpi::kbd_backlight' && sudo systemctl restart ipsec.service"
        ",switch:off:Lid Switch, exec, hyprctl keyword monitor 'eDP-1, 1920x1200, 0x0, 1.2' && brightnessctl set 100% --device='tpacpi::kbd_backlight' && brightnessctl set 70% --device='amdgpu_bl1'"
      ];

      bindel = [
        ",XF86MonBrightnessUp, exec, brightnessctl set +10% --device='amdgpu_bl1'"
        ",XF86MonBrightnessDown, exec, brightnessctl set 10%- --device='amdgpu_bl1'"
        ",XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"
        ",XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
        ",XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
      ];

      monitor = [
        # "${mon1},1920x1200,1440x0,1.2"
        # "${mon2},2560x1440,1440x1200,1"
        # "${mon3},2560x1440,0x1200,auto,transform,1"
        "desc:LG Electronics LG HDR WQHD+ 205NTCZ8L675,3840x1600@75,auto-up,1"
        ", preferred, 0x0, 1"
        # ", preferred, auto, 1, mirror, eDP-1"
      ];

      # monitor = [
      # "desc:Dell Inc. DELL U2415 7MT0167B2YNL,1920x1200@60,0x0,auto,transform,1"
      # "desc:AOC 28E850,disable"
      # ];

      workspace = [
        # "1, monitor:${mon2}, persistent:true, default:true"
        # "2, monitor:${mon3}, persistent:true, default:true, layoutopt:orientation:top"
        # "3, monitor:${mon2}, persistent:true, default:false"
        # "4, monitor:${mon3}, persistent:true, default:false, layoutopt:orientation:top"
        # "5, monitor:${mon2}, persistent:true, default:false"
        # "6, monitor:${mon3}, persistent:true, default:false, layoutopt:orientation:top"
        # "7, monitor:${mon2}, persistent:true, default:false"
        # "8, monitor:${mon3}, persistent:true, default:false, layoutopt:orientation:top"
        # "9, monitor:${mon2}, persistent:true, default:false"
        # "10, monitor:${mon3}, persistent:true, default:false, layoutopt:orientation:top"
      ];

      # windowrulev2 = float,class:(qalculate-gtk)
      # windowrulev2 = workspace special:calculator,class:(qalculate-gtk)
      # bind = SUPER, Q, exec, pgrep qalculate-gtk && hyprctl dispatch togglespecialworkspace calculator || qalculate-gtk &

      windowrulev2 = [
        "workspace 2, initialTitle:^(Gmail)$"
        "workspace 4, initialTitle:^(Google Calendar)$"
        "workspace 4, initialTitle:^(Google Chat)$"
        "workspace special:terminal,class:(kitty-dropdown)"
      ];

    };
  };

}
