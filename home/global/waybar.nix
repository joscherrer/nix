{ inputs, lib, pkgs, config, outputs, default, ... }:
with lib; let
  OSLogo = builtins.fetchurl rec {
    name = "OSLogo-${sha256}.png";
    sha256 = "14mbpw8jv1w2c5wvfvj8clmjw0fi956bq5xf9s2q3my14far0as8";
    url =
      "https://raw.githubusercontent.com/NixOS/nixos-artwork/master/logo/nix-snowflake.svg";
  };
  xcolors = default.xcolors;
in
{
  home.packages = with pkgs; [ python39Packages.requests ];
  programs.waybar = {
    enable = true;
    settings = {
      mainBar = {
        position = "top";
        layer = "top";
        height = 16;
        margin-top = 0;
        margin-bottom = 0;
        margin-left = 0;
        margin-right = 0;
        modules-left = [ "hyprland/window" ];
        # modules-left = [ "custom/launcher" "custom/playerctl" "custom/playerlabel" ];
        modules-center = [
          "hyprland/workspaces"
        ];
        modules-right = [
          "tray"
          "pulseaudio"
          "clock"
          # "custom/randwall"
          # "network"
        ];
        clock = {
          format = "󱑍 {:%H:%M}";
          tooltip = "true";
          tooltip-format = ''
            <big>{:%Y %B}</big>
            <tt><small>{calendar}</small></tt>'';
          format-alt = " {:%d/%m}";
        };

        "hyprland/workspaces" = {
          active-only = false;
          all-outputs = false;
          disable-scroll = false;
          on-scroll-up = "hyprctl dispatch workspace e-1";
          on-scroll-down = "hyprctl dispatch workspace e+1";
          format = "{icon}";
          on-click = "activate";
          show-special = "false";
          sort-by-number = true;
          persistent_workspaces = {
            "*" = 10;
          };
        };

        "hyprland/window" = {
          format = " {}";
          rewrite = {
            "(.*) — Mozilla Firefox" = "🌎 $1";
            "(.*) - fish" = "> [$1]";
          };
          separate-outputs = true;
        };

        "custom/playerctl" = {
          format = "{icon}";
          return-type = "json";
          max-length = 25;
          exec = ''
            playerctl -a metadata --format '{"text": "{{artist}} - {{markup_escape(title)}}", "tooltip": "{{playerName}} : {{markup_escape(title)}}", "alt": "{{status}}", "class": "{{status}}"}' -F'';
          on-click-middle = "playerctl play-pause";
          on-click = "playerctl previous";
          on-click-right = "playerctl next";
          format-icons = {
            Playing = "<span foreground='#6791eb'>󰓇 </span>";
            Paused = "<span foreground='#cdd6f4'>󰓇 </span>";
          };
        };

        "custom/playerlabel" = {
          format = "<span>{}</span>";
          return-type = "json";
          max-length = 25;
          exec = ''
            playerctl -a metadata --format '{"text": "{{artist}} - {{markup_escape(title)}}", "tooltip": "{{playerName}} : {{markup_escape(title)}}", "alt": "{{status}}", "class": "{{status}}"}' -F'';
          on-click-middle = "playerctl play-pause";
          on-click = "playerctl previous";
          on-click-right = "playerctl next";
          format-icons = {
            Playing = "<span foreground='#6791eb'>󰓇 </span>";
            Paused = "<span foreground='#cdd6f4'>󰓇 </span>";
          };
        };

        battery = {
          states = {
            good = 95;
            warning = 30;
            critical = 15;
          };
          format = "{icon}  {capacity}%";
          format-charging = "{capacity}% ";
          format-plugged = "{capacity}% ";
          format-alt = "{icon} {time}";
          # "format-good"= "", # An empty format will hide the module
          # "format-full"= "";
          format-icons = [ "" "" "" "" "" ];
        };

        memory = {
          format = "󰍛 {}%";
          format-alt = "󰍛 {used}/{total} GiB";
          interval = 30;
        };

        cpu = {
          format = "󰻠 {usage}%";
          format-alt = "󰻠 {avg_frequency} GHz";
          interval = 10;
        };

        disk = {
          format = "󰋊 {}%";
          format-alt = "󰋊 {used}/{total} GiB";
          interval = 30;
          path = "/";
        };

        network = {
          format-wifi = "󰤨";
          format-ethernet = " {ifname}: Aesthetic";
          format-linked = " {ifname} (No IP)";
          format-disconnected = "󰤭";
          format-alt = " {ifname}: {ipaddr}/{cidr}";
          tooltip-format = "{essid}";
          on-click-right = "nm-connection-editor";
        };

        tray = {
          icon-size = 18;
          spacing = 10;
        };

        backlight = {
          # "device"= "acpi_video1";
          format = "{icon} {percent}%";
          format-icons = [ "" "" "" "" "" "" "" "" "" ];
          #	"on-scroll-up"=;
          #	"on-scroll-down"=;
        };

        pulseaudio = {
          format = "{icon} {volume}%";
          format-muted = "";
          format-icons = { default = [ "" "" "" ]; };
          on-click = "bash ~/.scripts/volume mute";
          on-scroll-up = "bash ~/.scripts/volume up";
          on-scroll-down = "bash ~/.scripts/volume down";
          scroll-step = 5;
          on-click-right = "pavucontrol";
          tooltip = false;
        };
        "custom/randwall" = {
          format = "󰏘";
          on-click = "bash $HOME/.config/hypr/randwall.sh";
          on-click-right = "bash $HOME/.config/hypr/wall.sh";
        };
        "custom/launcher" = {
          format = "";
          # on-click = "notify-send -t 1 'swww' '1' & ~/.config/hypr/scripts/wall";
          tooltip = false;
        };

        "custom/wf-recorder" = {
          format = "{}";
          interval = "once";
          exec = "echo ''";
          tooltip = "false";
          exec-if = "pgrep 'wf-recorder'";
          on-click = "exec ./scripts/wlrecord.sh";
          signal = 8;
        };

        "custom/hyprpicker" = {
          format = "󰈋";
          on-click = "hyprpicker -a -f hex";
          on-click-right = "hyprpicker -a -f rgb";
        };
      };
    };
    style = ''
      * {
        border: none;
        border-radius: 0px;
        /* font-family: LigaSFMono Nerd Font, Iosevka, FontAwesome, Noto Sans CJK; */
        /* font-family: Iosevka, FontAwesome, Noto Sans CJK; */
        /* font-family: JetBrainsMono Nerd Font, FontAwesome, Noto Sans CJK; */
        font-family: CaskaydiaCove Nerd Font;
        font-size: 14px;
        font-style: normal;
        min-height: 0;
      }

      window#waybar {
        background: rgba(16,22,24, 0.9);
        transition-property: background-color;
        transition-duration: .5s;
        color: ${xcolors.fg}
      }

      tooltip {
        background: ${xcolors.bg};
        border-radius: 10px;
        border-width: 2px;
        border-style: solid;
        border-color: ${xcolors.bg};
      }

      #workspaces {
        background: ${xcolors.bg};
        margin: 5px 5px;
        padding: 8px 5px;
        border-radius: 16px;
        border: solid 0px ${xcolors.fg};
        font-weight: normal;
        font-style: normal;
      }

      #workspaces button {
        padding: 0px 5px;
        margin: 0px 3px;
        border-radius: 16px;
        color: #2f354a;
        background-color: #2f354a;
        transition: all 0.3s ease-in-out;
      }

      #workspaces button.active {
        color: ${xcolors.fg};
        background-color: ${xcolors.fg};
        border-radius: 16px;
        min-width: 50px;
        background-size: 400% 400%;
        transition: all 0.3s ease-in-out;
      }

      #workspaces button:hover {
        background-color: ${xcolors.fg};
        color: ${xcolors.fg};
        border-radius: 16px;
        min-width: 50px;
        background-size: 400% 400%;
      }

      #custom-date, #custom-playerctl, #clock, #battery, #pulseaudio, #network {
        background: ${xcolors.bg};
        color: ${xcolors.fg};
        padding: 0 6px;
        border-radius: 10px;
        margin: 6px 0px;
      }

      #pulseaudio, #tray, #clock, #custom-launcher {
        margin-right: 6px;
      }

      #cpu,
      #disk,
      #memory,
      #pulseaudio,
      #backlight,
      #battery,
      #network,
      #clock {
          border-radius: 10px;
      }

      #tray {
        color: ${xcolors.color4};
      }

      #tray>.passive {
        -gtk-icon-effect: dim;
      }

      #tray>.needs-attention {
        -gtk-icon-effect: highlight;
      }

      custom-launcher {
        font-size: 20px;
        margin: 0px 0px 2px 0px;
        border-radius: 0px 10px 0px 0px;
        padding: 10px 15px 10px 15px;
        color: ${xcolors.color12};
      }

      #pulseaudio {
        color: ${xcolors.fg};
      }

      #pulseaudio.muted {
        color: ${xcolors.color1};
      }
    '';
  };
}
