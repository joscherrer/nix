{ inputs, lib, pkgs, config, outputs, default, ... }:
let
  common-root = "${inputs.self}/dotfiles/common";
  colors = default.colors;
  screenshot-handler = pkgs.writeShellScriptBin "screenshot-handler" ''
    #!/usr/bin/env bash

    mode="$1"

    if [ "$mode" = "region" ]; then
      slurp | grim -g - - | wl-copy
    elif [ "$mode" = "window" ]; then
      hyprctl -j activewindow | jq -r '"\(.at[0]),\(.at[1]) \(.size[0])x\(.size[1])"' | grim -g - - | wl-copy
    fi
  '';
  waybar-wrapper = pkgs.writeShellScriptBin "waybar-wrapper" ''
    #!/usr/bin/env bash
    while true; do
      systemd-cat -t waybar waybar
      sleep 1
    done
  '';

  gather-windows = pkgs.writeScriptBin "gather-windows" (builtins.readFile "${inputs.self}/scripts/hyprdispatch");
  hyprdispatch = pkgs.writeScriptBin "hyprdispatch" (builtins.readFile "${inputs.self}/scripts/hyprdispatch");
in
rec
{
  home.packages = [
    screenshot-handler
    gather-windows
    hyprdispatch
    pkgs.hyprpaper
  ];

  xdg.configFile."hypr/hyprpaper.conf" = {
      text = ''
      preload = ${default.wallpaper}
      wallpaper = ,${default.wallpaper}
      '';
  };

  wayland.windowManager.hyprland = {
    enable = true;
    xwayland.enable = true;
    settings = {
      exec-once = [
        "dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP"
        "${pkgs.wl-clipboard}/bin/wl-paste --type text --watch cliphist store"
        "${pkgs.wl-clipboard}/bin/wl-paste --type image --watch cliphist store"
        "${waybar-wrapper}/bin/waybar-wrapper"
        "hyprpaper"
      ];

      exec = [
        # "pkill waybar-wrapper; systemd-cat -t waybar ${waybar-wrapper}/bin/waybar-wrapper --log-level trace"
        # "pkill hyprdispatch; systemd-cat --identifier=hyprdispatch ${hyprdispatch}/bin/hyprdispatch start"
        # "pkill kanshi; systemd-cat --identifier=kanshi kanshi"
        # "pkill swaybg; ${pkgs.swaybg}/bin/swaybg -i ${default.wallpaper} -m fill"
      ];

      monitor = [
        "desc:LG Electronics LG HDR WQHD+ 205NTCZ8L675,3840x1600@144,1920x0,1.25"
        "desc:Dell Inc. DELL U2415 7MT0167B2YNL,1920x1200@60,0x200,auto"
        "desc:AOC 28E850,disable"
        # "desc:AOC 28E850,1920x1080@60,6000x0,auto"
      ];

      env = [
        "XCURSOR_SIZE,24"
        "LIBVA_DRIVER_NAME,nvidia"
        "XDG_SESSION_TYPE,wayland"
        "GBM_BACKEND,nvidia-drm"
        "__GLX_VENDOR_LIBRARY_NAME,nvidia"
        "WLR_NO_HARDWARE_CURSORS,1"
        "GTK_THEME,Catppuccin-Mocha-Compact-Mauve-Dark"
        "XMODIFIERS=\"\""
      ];

      input = {
        kb_layout = "us";
        kb_options = "compose:ralt";
        # kb_variant = "intl";
        repeat_rate = 60;
        repeat_delay = 250;
        follow_mouse = 2;

        touchpad = {
          natural_scroll = false;
        };

        sensitivity = 0;
        accel_profile = "flat";
      };

      workspace = [
        "1, monitor:desc:LG Electronics LG HDR WQHD+ 205NTCZ8L675, persistent:true, default:true"
        "2, monitor:desc:Dell Inc. DELL U2415 7MT0167B2YNL, persistent:true, default:true"
        "3, monitor:desc:LG Electronics LG HDR WQHD+ 205NTCZ8L675, persistent:true, default:false"
        "4, monitor:desc:Dell Inc. DELL U2415 7MT0167B2YNL, persistent:true, default:false"
        "5, monitor:desc:LG Electronics LG HDR WQHD+ 205NTCZ8L675, persistent:true, default:false"
        "6, monitor:desc:Dell Inc. DELL U2415 7MT0167B2YNL, persistent:true, default:false"
        "7, monitor:desc:LG Electronics LG HDR WQHD+ 205NTCZ8L675, persistent:true, default:false"
        "8, monitor:desc:Dell Inc. DELL U2415 7MT0167B2YNL, persistent:true, default:false"
        "9, monitor:desc:LG Electronics LG HDR WQHD+ 205NTCZ8L675, persistent:true, default:false"
        "10, monitor:desc:Dell Inc. DELL U2415 7MT0167B2YNL, persistent:true, default:false"
        "11, monitor:desc:AOC 28E850, persistent:true, default:true"
      ];

      general = {
        gaps_in = 5;
        gaps_out = 5;
        border_size = 2;
        "col.active_border" = "rgb(${colors.background}) rgb(${colors.color8}) 270deg";
        "col.inactive_border" = "rgb(${colors.contrast}) rgb(${colors.color4}) 270deg";
        # group borders
        "no_border_on_floating" = false;
        layout = "master";
        no_cursor_warps = true;
      };

      group = {
        "col.border_active" = "rgb(${colors.color5})";
        "col.border_inactive" = "rgb(${colors.contrast})";
      };
      debug = {
          disable_logs = false;
      };

      misc = {
        disable_hyprland_logo = true;
      };

      decoration = {
        rounding = 5;
        blur = {
          size = 6;
          passes = 3;
          new_optimizations = true;
          ignore_opacity = true;
          noise = "0.1";
          contrast = "1.1";
          brightness = "1.2";
          xray = true;
        };

        drop_shadow = true;
        shadow_ignore_window = true;
        shadow_offset = "0 8";
        shadow_range = 50;
        shadow_render_power = 3;
        "col.shadow" = "rgba(00000099)";
        blurls = [ "gtk-layer-shell" "waybar" "lockscreen" ];
      };

      animations = {
        enabled = true;
        bezier = [
          "wind, 0.05, 0.9, 0.1, 1.05"
          "winIn, 0.1, 1.1, 0.1, 1.1"
          "winOut, 0.3, -0.3, 0, 1"
          "liner, 1, 1, 1, 1"
        ];

        animation = [
          "windows, 1, 6, wind, slide"
          "windowsIn, 1, 6, winIn, slide"
          "windowsOut, 1, 5, winOut, slide"
          "windowsMove, 1, 5, wind, slide"
          "border, 1, 1, liner"
          "borderangle, 1, 30, liner, loop"
          "fade, 1, 10, default"
          "workspaces, 1, 3, wind"
        ];
      };

      dwindle = {
        pseudotile = true;
        preserve_split = true;
        no_gaps_when_only = false;
      };

      master = {
        new_is_master = false;
        mfact = 0.66;
      };

      "$mainMod" = "SUPER";

      bind = [
        "$mainMod, Q, exec, kitty"
        "$mainMod, C, killactive,"
        "$mainMod, E, exec, dolphin"
        "$mainMod, F, fullscreen,"
        "$mainMod, M, fullscreen, 1"
        "$mainMod SHIFT, F, fakefullscreen,"
        "$mainMod, S, layoutmsg, swapwithmaster master"
        "$mainMod, V, exec, cliphist list | rofi -dmenu | cliphist decode | wl-copy && wtype -M ctrl -M shift v -m ctrl -m shift"
        "$mainMod, period, exec, rofimoji --action clipboard --clipboarder wl-copy"
        "$mainMod, W, layoutmsg, toggle split"
        "$mainMod, Space, exec, rofi -show drun"
        "$mainMod SHIFT, R, exec, gather-windows"
        "$mainMod, P, togglefloating,"
        "$mainMod, J, togglesplit, # dwindle"
        "$mainMod, L, exec, loginctl lock-session"
        "$mainMod, left, movefocus, l"
        "$mainMod, right, movefocus, r"
        "$mainMod, up, movefocus, u"
        "$mainMod, down, movefocus, d"
        "$mainMod, 1, workspace, 1"
        "$mainMod, 2, workspace, 2"
        "$mainMod, 3, workspace, 3"
        "$mainMod, 4, workspace, 4"
        "$mainMod, 5, workspace, 5"
        "$mainMod, 6, workspace, 6"
        "$mainMod, 7, workspace, 7"
        "$mainMod, 8, workspace, 8"
        "$mainMod, 9, workspace, 9"
        "$mainMod, 0, workspace, 10"
        "$mainMod SHIFT, 1, movetoworkspace, 1"
        "$mainMod SHIFT, 2, movetoworkspace, 2"
        "$mainMod SHIFT, 3, movetoworkspace, 3"
        "$mainMod SHIFT, 4, movetoworkspace, 4"
        "$mainMod SHIFT, 5, movetoworkspace, 5"
        "$mainMod SHIFT, 6, movetoworkspace, 6"
        "$mainMod SHIFT, 7, movetoworkspace, 7"
        "$mainMod SHIFT, 8, movetoworkspace, 8"
        "$mainMod SHIFT, 9, movetoworkspace, 9"
        "$mainMod SHIFT, 0, movetoworkspace, 10"
        "$mainMod, mouse_down, workspace, e+1"
        "$mainMod, mouse_up, workspace, e-1"
        ",Print, exec, slurp | grim -g - - | wl-copy"
        "SHIFT, Print, exec, hyprctl -j activewindow | jq -r '\"\\(.at[0]),\\(.at[1]) \\(.size[0])x\\(.size[1])\"' | grim -g - - | wl-copy"
        "SUPER CTRL ALT SHIFT, DELETE, exit,"
        "$mainMod SHIFT, Q, exec, wlogout -p layer-shell"
        "CTRL ALT, DELETE, exec, wlogout -p layer-shell"
      ];

      bindm = [
        "$mainMod, mouse:272, movewindow"
        "$mainMod, mouse:273, resizewindow"
      ];

      windowrulev2 = [
        "fakefullscreen, title:^(notion)$"
        "fakefullscreen, title:^(notion-calendar)$"
        "opacity 0.90 0.90,class:^(org.wezfurlong.wezterm)$"
        "opacity 0.90 0.90,class:^(Alacritty)$"
        "opacity 0.90 0.90,class:^(Brave-browser)$"
        "opacity 0.90 0.90,class:^(brave-browser)$"
        "opacity 0.95 0.95,class:^(firefox)$"
        "opacity 0.80 0.80,class:^(Steam)$"
        "opacity 0.80 0.80,class:^(steam)$"
        "opacity 0.80 0.80,class:^(steamwebhelper)$"
        "opacity 0.80 0.80,class:^(Spotify)$"
        "opacity 0.95 0.90,class:^(Code)$"
        "opacity 0.95 0.90,class:^(code-url-handler)$"
        "opacity 0.80 0.80,class:^(thunar)$"
        "opacity 0.80 0.80,class:^(file-roller)$"
        "opacity 0.80 0.80,class:^(nwg-look)$"
        "opacity 0.80 0.80,class:^(qt5ct)$"
        "opacity 0.80 0.80,class:^(discord)$"
        "opacity 0.80 0.80,class:^(WebCord)$"
        "opacity 0.80 0.70,class:^(pavucontrol)$"
        "opacity 0.80 0.70,class:^(org.kde.polkit-kde-authentication-agent-1)$"
        "opacity 0.80 0.80,class:^(org.telegram.desktop)$"
        "opacity 0.80 0.80,title:^(Spotify)$"

        "float,class:^(org.kde.polkit-kde-authentication-agent-1)$"
        "float,class:^(pavucontrol)$"
        "float,title:^(Media viewer)$"
        "float,title:^(Volume Control)$"
        "float,title:^(Picture-in-Picture)$"
        "float,class:^(Viewnior)$"
        "float,title:^(DevTools)$"
        "float,class:^(file_progress)$"
        "float,class:^(confirm)$"
        "float,class:^(dialog)$"
        "float,class:^(download)$"
        "float,class:^(notification)$"
        "float,class:^(error)$"
        "float,class:^(confirmreset)$"
        "float,title:^(Open File)$"
        "float,title:^(branchdialog)$"
        "float,title:^(Confirm to replace files)$"
        "float,title:^(File Operation Progress)$"
        "float,title:^(Qalculate!)$"
        "float,class:^(.blueman-manager-wrapped)$"
        # "nofullscreenrequest,class:^(firefox)$,title:^(Mozilla Firefox)$"
        # "float,title:^(Mozilla Firefox)$"
        # "move 50% 50%,class:^(firefox)$,floating:1"

        # "nomaximizerequest,class:^(firefox)$"
        
        "noshadow, floating:0"

        "tile, title:^(Spotify)$"
        "workspace 9 silent, title:^(Spotify)$"
        "workspace 4, title:^(.*(Disc|WebC)ord.*)$"

        "idleinhibit focus, class:^(mpv|.+exe)$"
        "idleinhibit focus, class:^(firefox)$, title:^(.*YouTube.*)$"
        "idleinhibit fullscreen, class:^(firefox)$"
        "idleinhibit fullscreen,class:^(Brave-browser)$"

        "rounding 0, xwayland:1, floating:1"
        "center, class:^(.*jetbrains.*)$, title:^(Confirm Exit|Open Project|win424|win201|splash)$"
        "size 640 400, class:^(.*jetbrains.*)$, title:^(splash)$"

        "opacity 0.0 override 0.0 override,class:^(xwaylandvideobridge)$"
        "noanim,class:^(xwaylandvideobridge)$"
        "nofocus,class:^(xwaylandvideobridge)$"
        "noinitialfocus,class:^(xwaylandvideobridge)$"
        "noblur,class:^(xwaylandvideobridge)$"
        "noshadow,class:^(xwaylandvideobridge)$"
      ];
      layerrule = [
        "blur, ^(gtk-layer-shell|anyrun)$"
        "ignorezero, ^(gtk-layer-shell|anyrun)$"
        "blur, notifications"
        "blur, launcher"
      ];
    };
  };
}
