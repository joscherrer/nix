{
  inputs,
  lib,
  pkgs,
  config,
  outputs,
  default,
  ...
}:
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

  toggle-browser = pkgs.writeShellScriptBin "toggle-browser" ''
    #!/usr/bin/env bash
    wname=$(hyprctl clients -j | jq -e -r '.[] | select(.class == "google-chrome") | .workspace.name')
    # currw=$(hyprctl activeworkspace -j | jq -r '.name')
    if [ "$wname" != "special:browser" ]; then
      hyprctl dispatch togglespecialworkspace browser 
      hyprctl dispatch movetoworkspace special:browser,class:google-chrome
    else 
      cposx=$(hyprctl cursorpos -j | jq -e -r '.x')
      cposy=$(hyprctl cursorpos -j | jq -e -r '.y')
      hyprctl dispatch togglespecialworkspace browser 
      hyprctl dispatch movetoworkspace 2,class:google-chrome
      hyprctl dispatch movecursor $cposx $cposy
    fi
  '';

  toggle-win = pkgs.writeShellScriptBin "toggle-win" ''
    selector=$1
    selname=$(cut -d":" -f1 <<< "$selector")
    selnamelower=$(awk '{print tolower($0)}' <<< "$selname")
    selvalue=$(cut -d":" -f2 <<< "$selector")
    workspace_name=$2
    workspace_num=''${3:=2}
    wname=$(hyprctl clients -j | jq -e -r '.[] | select(.'$selname' == "'"$selvalue"'") | .workspace.name')
    if [ $? -ne 0 ]; then exit 0; fi

    if [ "$wname" != "special:$workspace_name" ]; then
      hyprctl dispatch togglespecialworkspace $workspace_name 
      hyprctl dispatch movetoworkspace "special:$workspace_name,$selnamelower:$selvalue"
    else 
      cposx=$(hyprctl cursorpos -j | jq -e -r '.x')
      cposy=$(hyprctl cursorpos -j | jq -e -r '.y')
      hyprctl dispatch togglespecialworkspace $workspace_name 
      hyprctl dispatch movetoworkspacesilent "$workspace_num,$selnamelower:$selvalue"
      hyprctl dispatch movecursor $cposx $cposy
    fi
  '';

  screenrecorder = pkgs.writeShellScriptBin "screenrecorder" ''
    #!/usr/bin/env bash

    mode="$1"

    wf-recorder_check() {
      if pgrep -x "wf-recorder" > /dev/null; then
          pkill -INT -x wf-recorder
          notify-send "Stopping all instances of wf-recorder" "$(cat /tmp/recording.txt)"
          wl-copy < "$(cat /tmp/recording.txt)"
          exit 0
      fi
    }

    wf-recorder_check

    if [ "$mode" = "region" ]; then
      pos=$(slurp)
      ${pkgs.wf-recorder}/bin/wf-recorder -g "$pos" -f "$HOME"/ScreenRecordings/$(date +%Y-%m-%d_%H-%M-%S).mp4
    fi

  '';

  waybar-wrapper = pkgs.writeShellScriptBin "waybar-wrapper" ''
    #!/usr/bin/env bash
    while true; do
      systemd-cat -t waybar waybar
      sleep 1
    done
  '';

  hyprdispatch = pkgs.writeScriptBin "hyprdispatch" (
    builtins.readFile "${inputs.self}/scripts/hyprdispatch"
  );
in
rec {
  home.packages = [
    screenshot-handler
    hyprdispatch
    pkgs.bibata-cursors
    pkgs.hyprpicker
    toggle-win
    pkgs.hyprlauncher
  ];

  services.hyprpaper = {
    enable = true;
    settings = {
      preload = [
        "${default.wallpaper}"
      ];
      wallpaper = [
        ",${default.wallpaper}"
      ];
    };
  };

  programs.hyprlock = {
    enable = true;
    settings = {
      general = {
        disable_loading_bar = true;
        grace = 0;
        hide_cursor = true;
        no_fade_in = false;
      };

      background = [
        {
          path = "screenshot";
          blur_passes = 3;
          blur_size = 8;
        }
      ];

      input-field = [
        {
          size = "200, 50";
          position = "0, -80";
          monitor = "";
          dots_center = true;
          fade_on_empty = false;
          font_color = "rgb(202, 211, 245)";
          inner_color = "rgb(91, 96, 120)";
          outer_color = "rgb(24, 25, 38)";
          outline_thickness = 5;
          placeholder_text = ''<span foreground="##cad3f5">Password...</span>'';
          shadow_passes = 2;
        }
      ];
    };
  };

  services.hypridle = {
    enable = true;
    settings = {
      general = {
        lock_cmd = "pidof hyprlock || hyprlock";
        before_sleep_cmd = "loginctl lock-session";
        after_sleep_cmd = "hyprctl dispatch dpms on";
      };

      listener = [
        {
          timeout = 300;
          on-timeout = "loginctl lock-session";
          on-resume = "${hyprdispatch}/bin/hyprdispatch";
        }
        {
          timeout = 600;
          on-timeout = "systemctl suspend";
          on-resume = "${hyprdispatch}/bin/hyprdispatch";
        }
      ];
    };
  };

  services.network-manager-applet.enable = true;

  wayland.windowManager.hyprland = {
    plugins = [
      # pkgs.hyprlandPlugins.hyprexpo
      # pkgs.hyprlandPlugins.hyprsplit
    ];

    enable = true;
    xwayland.enable = true;
    settings = {
      exec-once = [
        "dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP"
        # "${pkgs.wl-clipboard}/bin/wl-paste --type text --watch cliphist store"
        # "${pkgs.wl-clipboard}/bin/wl-paste --type image --watch cliphist store"
        # "${waybar-wrapper}/bin/waybar-wrapper"
        # "hyprlauncher -d"
        "${pkgs.vicinae}/bin/vicinae server"
        "ashell"
        # "${pkgs.networkmanagerapplet}/bin/nm-applet --indicator"
        # "hyprswitch init --show-title --custom-css ${config.xdg.configHome}/hyprswitch/style.css &"
      ];

      monitor = [
        # "desc:LG Electronics LG HDR WQHD+ 205NTCZ8L675,3840x1600@144,1200x160,1.25"
        # "desc:Dell Inc. DELL U2415 7MT0167B2YNL,1920x1200@60,0x0,auto,transform,1"
        # "desc:AOC 28E850,disable"
      ];

      env = [
        "LIBVA_DRIVER_NAME,nvidia"
        "XDG_SESSION_TYPE,wayland"
        "GBM_BACKEND,nvidia-drm"
        "__GLX_VENDOR_LIBRARY_NAME,nvidia"
        "WLR_NO_HARDWARE_CURSORS,1"
        "GTK_THEME,catppuccin-mocha-mauve-compact+normal"
        "XMODIFIERS=\"\""
        "XCURSOR_SIZE,24"
        "XCURSOR_THEME,Bibata-Modern-Classic"
        "HYPRCURSOR_SIZE,24"
        "HYPRCURSOR_THEME,Bibata-Modern-Classic"
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

      device = [
        {
          name = "at-translated-set-2-keyboard";
          kb_options = "caps:swapescape";
        }
      ];

      workspace = [
        # "1, monitor:desc:LG Electronics LG HDR WQHD+ 205NTCZ8L675, persistent:true, default:true"
        # "2, monitor:desc:Dell Inc. DELL U2415 7MT0167B2YNL, persistent:true, default:true, layoutopt:orientation:top"
        # "3, monitor:desc:LG Electronics LG HDR WQHD+ 205NTCZ8L675, persistent:true, default:false"
        # "4, monitor:desc:Dell Inc. DELL U2415 7MT0167B2YNL, persistent:true, default:false, layoutopt:orientation:top"
        # "5, monitor:desc:LG Electronics LG HDR WQHD+ 205NTCZ8L675, persistent:true, default:false"
        # "6, monitor:desc:Dell Inc. DELL U2415 7MT0167B2YNL, persistent:true, default:false, layoutopt:orientation:top"
        # "7, monitor:desc:LG Electronics LG HDR WQHD+ 205NTCZ8L675, persistent:true, default:false"
        # "8, monitor:desc:Dell Inc. DELL U2415 7MT0167B2YNL, persistent:true, default:false, layoutopt:orientation:top"
        # "9, monitor:desc:LG Electronics LG HDR WQHD+ 205NTCZ8L675, persistent:true, default:false"
        # "10, monitor:desc:Dell Inc. DELL U2415 7MT0167B2YNL, persistent:true, default:false, layoutopt:orientation:top"
        # "11, monitor:desc:AOC 28E850, persistent:true, default:true"
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
        # no_cursor_warps = true;
      };

      source = [
        "~/.config/hypr/tests.conf"
      ];

      group = {
        # "col.border_active" = "rgb(${colors.color5})";
        # "col.border_inactive" = "rgb(${colors.contrast})";
      };
      debug = {
        disable_logs = false;
      };

      misc = {
        disable_hyprland_logo = true;
        focus_on_activate = true;
      };

      xwayland = {
        force_zero_scaling = true;
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

        shadow = {
          enabled = true;
          ignore_window = true;
          offset = "0 8";
          range = 50;
          render_power = 3;
          color = "rgba(00000099)";
        };
        blurls = [
          "gtk-layer-shell"
          "lockscreen"
        ];
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
      };

      master = {
        new_status = "slave";
        mfact = 0.66;
      };

      "$mainMod" = "SUPER";

      binds = {
        movefocus_cycles_fullscreen = true;
      };

      bind = [
        "$mainMod, Q, exec, kitty"
        "$mainMod, C, killactive,"
        "$mainMod, E, exec, ${pkgs.xfce.thunar}/bin/thunar"
        "$mainMod, F, fullscreen,"
        "$mainMod, M, fullscreen, 1"
        "$mainMod SHIFT, F, fullscreenstate, -1, 2"
        "$mainMod, S, layoutmsg, swapwithmaster master"
        # "$mainMod, V, exec, cliphist list | rofi -dmenu | cliphist decode | wl-copy && wtype -M ctrl -M shift v -m ctrl -m shift"
        "$mainMod, V, exec, vicinae vicinae://extensions/vicinae/clipboard/history"
        "$mainMod ALT, C, exec, hyprpicker -a --no-fancy -r"
        "$mainMod, period, exec, rofi -modi 'emoji:rofimoji' -show emoji | wl-copy"
        "$mainMod, W, layoutmsg, toggle split"
        # "$mainMod, Space, exec, rofi -show drun"
        "$mainMod SHIFT, R, exec, hyprdispatch"
        "$mainMod, P, togglefloating,"
        "$mainMod SHIFT, P, pin,"
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
        "$mainMod CTRL, B, tagwindow, pin:bbrain"
        "$mainMod CTRL, W, tagwindow, pin:work"
        ",Print, exec, slurp | grim -g - - | wl-copy"
        "SHIFT, Print, exec, hyprctl -j activewindow | jq -r '\"\\(.at[0]),\\(.at[1]) \\(.size[0])x\\(.size[1])\"' | grim -g - - | wl-copy"
        "CTRL, Print, exec, ${screenrecorder}/bin/screenrecorder region"
        "SUPER CTRL ALT SHIFT, DELETE, exit,"
        "CTRL ALT, DELETE, exec, wlogout -p layer-shell"
        # "SUPER, grave, hyprexpo:expo, toggle"
        "$mainMod, Space, exec, ${pkgs.vicinae}/bin/vicinae toggle"
        "$mainMod, T, exec, ${pkgs.vicinae}/bin/vicinae vicinae://extensions/vicinae/wm/switch-windows"
      ];

      bindm = [
        "$mainMod, mouse:272, movewindow"
        "$mainMod, mouse:273, resizewindow"
      ];

      windowrulev2 = [
        # "bordercolor rgb(${colors.color9}) rgb(${colors.color9}) 270deg, fullscreen:1"
        # "bordercolor rgb(${colors.color9}) rgb(${colors.color9}) 270deg, fullscreenstate:2 2"
        # "bordercolor rgb(${colors.color9}) rgb(${colors.color9}) 270deg, fullscreenstate:3 3"

        "fullscreenstate -1 2, title:^(notion)$"
        "fullscreenstate -1 2, title:^(notion-calendar)$"
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
        "opacity 1 1,class:^(WebCord)$"
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

        # "bordercolor rgb(${colors.color9}), tag:pin:bbrain"
        # "bordercolor g${colors.color9}) color(${colors.color1}) 270deg, tag:pin:work"

        "noshadow, floating:0"

        "tile, title:^(Spotify)$"
        "workspace 9 silent, title:^(Spotify)$"
        "workspace 4, title:^(.*(Disc|WebC)ord.*)$"
        "workspace 2, class:^(firefox)$,title:^(Mozilla Firefox)$"
        "workspace 8, initialClass:^(.*com.jumbomana.avatar.*)$"
        "fullscreen, initialClass:^(.*com.jumbomana.avatar.*)$"

        "idleinhibit focus, class:^(mpv|.+exe)$"
        "idleinhibit focus, class:^(firefox)$, title:^(.*YouTube.*)$"
        "idleinhibit fullscreen, class:^(firefox)$"
        "idleinhibit fullscreen,class:^(Brave-browser)$"

        # "rounding 0, xwayland:1, floating:1"
        "center, class:^(.*jetbrains.*)$, title:^(Confirm Exit|Open Project|win424|win201|splash)$"
        "size 640 400, class:^(.*jetbrains.*)$, title:^(splash)$"

        "opacity 0.0 override 0.0 override,class:^(xwaylandvideobridge)$"
        "noanim,class:^(xwaylandvideobridge)$"
        "nofocus,class:^(xwaylandvideobridge)$"
        "noinitialfocus,class:^(xwaylandvideobridge)$"
        "noblur,class:^(xwaylandvideobridge)$"
        "noshadow,class:^(xwaylandvideobridge)$"
        "noblur,title:^(Picture-in-Picture)$"
        "opacity 1.0 1.0,title:^(Picture-in-Picture)$"
        # "bordersize 0, floating:0, onworkspace:w[tv1]"
        # "rounding 0, floating:0, onworkspace:w[tv1]"
        # "bordersize 0, floating:0, onworkspace:f[1]"
        # "rounding 0, floating:0, onworkspace:f[1]"

        # "bordercolor rgb(${colors.color9}), fullscreenstate:* 1"
        # "bordercolor rgb(${colors.color9}), fullscreenstate:* 2"
        "bordercolor rgb(${colors.color9}) rgb(${colors.color9}), fullscreen:1"
      ];
      layerrule = [
        "blur, ^(gtk-layer-shell|anyrun)$"
        "ignorezero, ^(gtk-layer-shell|anyrun)$"
        "blur, notifications"
        "blurpopups, notifications"
        "ignorealpha 0, notifications"
        "blur, launcher"
        "blur, vicinae"
        "blurpopups, vicinae"
        "ignorealpha 0.8, vicinae"
        "noanim, vicinae"
      ];
    };
    extraConfig = '''';
  };
}
