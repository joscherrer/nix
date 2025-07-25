{
  inputs,
  lib,
  pkgs,
  config,
  outputs,
  default,
  ...
}:
with lib;
let
  OSLogo = builtins.fetchurl rec {
    name = "OSLogo-${sha256}.png";
    sha256 = "14mbpw8jv1w2c5wvfvj8clmjw0fi956bq5xf9s2q3my14far0as8";
    url = "https://raw.githubusercontent.com/NixOS/nixos-artwork/master/logo/nix-snowflake.svg";
  };
  xcolors = default.xcolors;
in
{
  catppuccin.waybar = {
    enable = true;
  };

  programs.waybar = {
    enable = true;

    settings = {
      mainBar = {
        position = "top";
        layer = "top";
        height = 16;
        margin = "5";
        margin-top = 0;
        margin-bottom = 0;
        margin-left = 0;
        margin-right = 0;
        reload_style_on_change = true;
        modules-left = [
          "hyprland/workspaces"
        ];
        modules-center = [
          "hyprland/window"
        ];
        modules-right = [
          "tray"
          "custom/lock"
          "pulseaudio"
          "clock"
          # "custom/randwall"
          # "network"
        ];
        clock = {
          format = "󱑍  {:%H:%M}";
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
          "format-icons" = {
            "1" = "";
            "2" = "";
            "3" = "";
            "4" = "";
            "5" = "";
            "active" = "";
            "default" = "";
          };
          # persistent_workspaces = {
          #   "*" = 10;
          # };
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
          exec = ''playerctl -a metadata --format '{"text": "{{artist}} - {{markup_escape(title)}}", "tooltip": "{{playerName}} : {{markup_escape(title)}}", "alt": "{{status}}", "class": "{{status}}"}' -F'';
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
          exec = ''playerctl -a metadata --format '{"text": "{{artist}} - {{markup_escape(title)}}", "tooltip": "{{playerName}} : {{markup_escape(title)}}", "alt": "{{status}}", "class": "{{status}}"}' -F'';
          on-click-middle = "playerctl play-pause";
          on-click = "playerctl previous";
          on-click-right = "playerctl next";
          format-icons = {
            Playing = "<span foreground='#6791eb'>󰓇 </span>";
            Paused = "<span foreground='#cdd6f4'>󰓇 </span>";
          };
        };

        "custom/lock" = {
          tooltip = false;
          on-click = "loginctl lock-session";
          format = "";
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
          icon-size = 17;
          spacing = 8;
        };

        pulseaudio = {
          format = "{icon}  {volume}%";
          format-muted = "";
          format-icons = {
            default = [
              ""
              ""
              ""
            ];
          };
          on-click = "pamixer --toggle-mute";
          on-scroll-up = "pamixer --increase 5";
          on-scroll-down = "pamixer --decrease 5";
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
        font-family: FantasqueSansMono Nerd Font;
        font-size: 17px;
        min-height: 0px;
      }

      #waybar {
        /* background: transparent; */
        background: rgba(0,0,0,0.7);
        color: @text;
        margin: 0px;
        border: 0px solid rgba(0, 0, 0, 0);
        border-radius: 0rem;
      }

      :hover {
          background: rgba(0,0,0,0);
      }


      .modules {
        margin: 0px;
        padding: 0px;
        outline-width: 0px;
      }


      .modules-right,
      .modules-center,
      .modules-left {
        border-radius: 0rem;
        margin: 0px 0px;
        padding: 0px;
        outline-width: 0px;
        /* background-color: @surface0; */
      }



      #workspaces {
        margin-left: 0px;
        margin-right: 0px;
      }

      #workspaces button {
        color: @white;
        border-radius: 0rem;
        padding-left: 0.4rem;
        padding-right: 0.95rem;
        border-bottom: 2px solid rgba(0, 0, 0, 0);
      }

      #workspaces button.active {
        color: @white;
        border-radius: 0rem;
        border-bottom: 2px solid @white;
      }

      #workspaces button:hover {
        color: @white;
        border-radius: 0rem;
        background: rgba(255,255,255,0.1);
        box-shadow: 0px 0px 0px 0px @white;
      }


      #custom-music,
      #tray,
      #backlight,
      #clock,
      #battery,
      #pulseaudio,
      #custom-lock,
      #window,
      #custom-power {
        /* background-color: @surface0; */
        padding: 0rem 5px;
        margin: 0;
        font-size: 15px;
      }

      #window label {
        color: @white;
        font-size: 14px;
      }

      #clock {
        color: @white;
        border-radius: 0px 1rem 1rem 0px;
        margin-right: 1rem;
      }

      #pulseaudio {
        color: @white;
        border-radius: 1rem 0px 0px 1rem;
        margin-left: 1rem;
      }

      #custom-music {
        color: @mauve;
        border-radius: 1rem;
      }

      #custom-lock {
          border-radius: 0;
          color: @white;
      }

      #tray {
        margin-right: 0rem;
        border-radius: 0rem;
      }
    '';
    # style = ''
    #   * {
    #     border: none;
    #     border-radius: 0px;
    #     /* font-family: LigaSFMono Nerd Font, Iosevka, FontAwesome, Noto Sans CJK; */
    #     /* font-family: Iosevka, FontAwesome, Noto Sans CJK; */
    #     /* font-family: JetBrainsMono Nerd Font, FontAwesome, Noto Sans CJK; */
    #     font-family: CaskaydiaCove Nerd Font;
    #     font-size: 14px;
    #     font-style: normal;
    #     min-height: 0;
    #   }
    #
    #   window#waybar {
    #     background: rgba(16,22,24, 0.9);
    #     transition-property: background-color;
    #     transition-duration: .5s;
    #     color: ${xcolors.fg}
    #   }
    #
    #   tooltip {
    #     background: ${xcolors.bg};
    #     border-radius: 10px;
    #     border-width: 2px;
    #     border-style: solid;
    #     border-color: ${xcolors.bg};
    #   }
    #
    #   #workspaces {
    #     background: ${xcolors.bg};
    #     margin: 5px 5px;
    #     padding: 8px 5px;
    #     border-radius: 16px;
    #     border: solid 0px ${xcolors.fg};
    #     font-weight: normal;
    #     font-style: normal;
    #   }
    #
    #   #workspaces button {
    #     padding: 0px 5px;
    #     margin: 0px 3px;
    #     border-radius: 16px;
    #     color: #2f354a;
    #     background-color: #2f354a;
    #     transition: all 0.3s ease-in-out;
    #   }
    #
    #   #workspaces button.active {
    #     color: ${xcolors.fg};
    #     background-color: ${xcolors.fg};
    #     border-radius: 16px;
    #     min-width: 50px;
    #     background-size: 400% 400%;
    #     transition: all 0.3s ease-in-out;
    #   }
    #
    #   #workspaces button:hover {
    #     background-color: ${xcolors.fg};
    #     color: ${xcolors.fg};
    #     border-radius: 16px;
    #     min-width: 50px;
    #     background-size: 400% 400%;
    #   }
    #
    #   #custom-date, #custom-playerctl, #clock, #battery, #pulseaudio, #network {
    #     background: ${xcolors.bg};
    #     color: ${xcolors.fg};
    #     padding: 0 6px;
    #     border-radius: 10px;
    #     margin: 6px 0px;
    #   }
    #
    #   #pulseaudio, #tray, #clock, #custom-launcher {
    #     margin-right: 6px;
    #   }
    #
    #   #cpu,
    #   #disk,
    #   #memory,
    #   #pulseaudio,
    #   #backlight,
    #   #battery,
    #   #network,
    #   #clock {
    #       border-radius: 10px;
    #   }
    #
    #   #tray {
    #     color: ${xcolors.color4};
    #   }
    #
    #   #tray>.passive {
    #     -gtk-icon-effect: dim;
    #   }
    #
    #   #tray>.needs-attention {
    #     -gtk-icon-effect: highlight;
    #   }
    #
    #   custom-launcher {
    #     font-size: 20px;
    #     margin: 0px 0px 2px 0px;
    #     border-radius: 0px 10px 0px 0px;
    #     padding: 10px 15px 10px 15px;
    #     color: ${xcolors.color12};
    #   }
    #
    #   #pulseaudio {
    #     color: ${xcolors.fg};
    #   }
    #
    #   #pulseaudio.muted {
    #     color: ${xcolors.color1};
    #     padding-right: 10px;
    #   }
    # '';
  };
}
