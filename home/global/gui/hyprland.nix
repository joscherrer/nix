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
  fetchToFarm = w: {
    name = builtins.baseNameOf w.url;
    path = builtins.fetchurl w;
  };

  wallpapers = pkgs.linkFarm "wallpapers" (
    map fetchToFarm [
      {
        url = "https://w.wallhaven.cc/full/x6/wallhaven-x6919l.jpg";
        sha256 = "sha256:1zy78h1a8r3frx4yfablnzj8x0wvly9zhqgfl6mg0ab4vcgk055d";
      }
      {
        url = "https://w.wallhaven.cc/full/w5/wallhaven-w51eor.png";
        sha256 = "sha256:1jpzckcny1r0d4jkfrvhq6qj9vdsm2rfkdz131myz2gpvv5xgm98";
      }
      {
        url = "https://w.wallhaven.cc/full/nm/wallhaven-nmmvvk.jpg";
        sha256 = "sha256:0lba5h6p4pfjwpvnn0gvckrll6kwhs88z49nhlvijc821i1yp19w";
      }
    ]
  );
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
      hyprctl dispatch 'hl.dsp.togglespecialworkspace("browser")'
      hyprctl dispatch 'hl.dsp.movetoworkspace("special:browser,class:google-chrome")'
    else
      cposx=$(hyprctl cursorpos -j | jq -e -r '.x')
      cposy=$(hyprctl cursorpos -j | jq -e -r '.y')
      hyprctl dispatch 'hl.dsp.togglespecialworkspace("browser")'
      hyprctl dispatch 'hl.dsp.movetoworkspace("2,class:google-chrome")'
      hyprctl dispatch "hl.dsp.movecursor(\"$cposx $cposy\")"
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
      hyprctl dispatch "hl.dsp.togglespecialworkspace(\"$workspace_name\")"
      hyprctl dispatch "hl.dsp.movetoworkspace(\"special:$workspace_name,$selnamelower:$selvalue\")"
    else
      cposx=$(hyprctl cursorpos -j | jq -e -r '.x')
      cposy=$(hyprctl cursorpos -j | jq -e -r '.y')
      hyprctl dispatch "hl.dsp.togglespecialworkspace(\"$workspace_name\")"
      hyprctl dispatch "hl.dsp.movetoworkspacesilent(\"$workspace_num,$selnamelower:$selvalue\")"
      hyprctl dispatch "hl.dsp.movecursor(\"$cposx $cposy\")"
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

  # Scripts below are plain `#!/usr/bin/env python3` files on disk (so
  # they stay directly runnable for local testing), but that shebang
  # resolves whatever `python3` happens to win PATH priority at
  # runtime - which may not have `sh` installed (e.g. a plain
  # pkgs.python311 in home.packages shadows the system one that does,
  # since per-user packages take priority). Pin an explicit interpreter
  # instead of trusting PATH: the real shebang below wins, and the
  # script's own `#!/usr/bin/env python3` line just becomes an inert
  # comment on line 2.
  pythonWithSh = pkgs.python3.withPackages (ps: [ ps.sh ]);
  pythonScriptBin =
    name: path:
    pkgs.writeScriptBin name ''
      #!${pythonWithSh}/bin/python3
      ${builtins.readFile path}
    '';

  hyprdispatch = pythonScriptBin "hyprdispatch" "${inputs.self}/scripts/hyprdispatch";

  gather-windows = pythonScriptBin "gather-windows" "${inputs.self}/scripts/gather-windows";

  fix-monitors = pythonScriptBin "fix-monitors" "${inputs.self}/scripts/fix-monitors";

  monitors-broken = pythonScriptBin "monitors-broken" "${inputs.self}/scripts/monitors-broken";
in
rec {
  home.packages = [
    screenshot-handler
    hyprdispatch
    gather-windows
    fix-monitors
    monitors-broken
    pkgs.libnotify
    pkgs.bibata-cursors
    pkgs.hyprpicker
    toggle-win
    pkgs.hyprlauncher
    pkgs.nwg-displays
  ];

  services.hyprpaper = {
    enable = true;
    settings = {
      splash = false;
      wallpaper = [
        {
          monitor = "";
          path = "${wallpapers}";
          fit_mode = "cover";
        }
      ];
    };
  };

  programs.hyprlock = {
    enable = true;
    settings = {
      general = {
        disable_loading_bar = true;
        grace = 0;
        hide_cursor = false;
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
          monitor = "";
          size = "300, 60";
          outline_thickness = 4;
          dots_size = 0.2;
          dots_spacing = 0.2;
          dots_center = true;
          outer_color = colors.catpuccin.blue;
          inner_color = colors.catpuccin.surface0;
          font_color = colors.catpuccin.text;
          fade_on_empty = false;
          placeholder_text = ''<span foreground="#${colors.catpuccin.textAlpha}"><i>󰌾 Logged in as </i><span foreground="#${colors.catpuccin.blueAlpha}">$USER</span></span>'';
          hide_input = false;
          check_color = colors.catpuccin.blue;
          fail_color = colors.catpuccin.red;
          fail_text = "<i>$FAIL <b>($ATTEMPTS)</b></i>";
          capslock_color = colors.catpuccin.yellow;
          position = "0, -47";
          halign = "center";
          valign = "center";
          # shadow_passes = 2;
        }
      ];

      label = [
        {
          text = "$TIME";
          color = "white";
          font_size = 90;
          font_family = "JetBrains Mono";
          position = "-30, 0";
          halign = "right";
          valign = "top";
        }
        {
          text = ''cmd[update:43200000] date +"%A, %d %B %Y"'';
          color = "white";
          font_size = 25;
          font_family = "JetBrains Mono";
          position = "-30, -150";
          halign = "right";
          valign = "top";
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
        # after_sleep_cmd = "sleep 3 && hyprctl dispatch 'hl.dsp.force_renderer_reload()'";
        # after_sleep_cmd = ''sleep 3 && hyprctl dispatch 'hl.dsp.dpms("on")'; hyprctl dispatch 'hl.dsp.force_renderer_reload()'';
      };

      listener = [
        {
          timeout = 300;
          on-timeout = "loginctl lock-session";
          on-resume = "${hyprdispatch}/bin/hyprdispatch";
        }
        {
          timeout = 1200;
          on-timeout = "systemctl suspend";
          on-resume = "${hyprdispatch}/bin/hyprdispatch";
        }
      ];
    };
  };

  services.network-manager-applet.enable = true;

  wayland.windowManager.hyprland =
    let
      hyprDir = "${inputs.self}/dotfiles/common/.config/hypr";
      # Every top-level .lua file is auto-loaded by the generated hyprland.lua.
      topLevel = lib.filterAttrs (n: t: t == "regular" && lib.hasSuffix ".lua" n) (
        builtins.readDir hyprDir
      );
      autoLoaded = lib.mapAttrs' (
        n: _:
        lib.nameValuePair (lib.removeSuffix ".lua" n) { content = builtins.readFile "${hyprDir}/${n}"; }
      ) topLevel;
      # base/ is shared with the greetd greeter (hosts/common/greetd.nix);
      # only base/init.lua is required, it pulls in the rest.
      base = lib.mapAttrs' (
        n: _:
        lib.nameValuePair "base.${lib.removeSuffix ".lua" n}" {
          content = builtins.readFile "${hyprDir}/base/${n}";
          autoLoad = n == "init.lua";
        }
      ) (builtins.readDir "${hyprDir}/base");
    in
    {
      plugins = [ ];

      enable = true;
      configType = "lua";
      xwayland.enable = true;

      # Per-host monitor layout: set extraLuaFiles.host in home/jscherrer/<host>.nix
      # to dotfiles/hosts/<host>/hypr/host.lua (see base/monitors.lua).
      extraLuaFiles = autoLoaded // base;

      settings = {
        bind = [
          {
            _args = [
              "CTRL + Print"
              (lib.generators.mkLuaInline "function() hl.exec_cmd(\"${screenrecorder}/bin/screenrecorder region\") end")
            ];
          }
          {
            _args = [
              "SUPER + Space"
              (lib.generators.mkLuaInline "function() hl.exec_cmd(\"${pkgs.vicinae}/bin/vicinae toggle\") end")
            ];
          }
          {
            _args = [
              "SUPER + T"
              (lib.generators.mkLuaInline "function() hl.exec_cmd(\"${pkgs.vicinae}/bin/vicinae vicinae://extensions/vicinae/wm/switch-windows\") end")
            ];
          }
        ];
      };
    };
}
