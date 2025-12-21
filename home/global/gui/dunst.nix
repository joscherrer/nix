{
  inputs,
  lib,
  pkgs,
  config,
  outputs,
  default,
  ...
}:
{
  services.dunst = {
    enable = true;
    settings = {
      global = {
        # Display
        monitor = 0;
        follow = "mouse";

        # Geometry
        width = 300;
        height = 300;
        origin = "top-right";
        offset = "10x30";
        scale = 0;
        notification_limit = 0;

        # Progress bar
        progress_bar = true;
        progress_bar_height = 10;
        progress_bar_frame_width = 1;
        progress_bar_min_width = 150;
        progress_bar_max_width = 300;

        # Appearance
        indicate_hidden = "yes";
        transparency = 25;
        separator_height = 1;
        padding = 8;
        horizontal_padding = 10;
        text_icon_padding = 0;
        frame_width = 0;
        frame_color = "#282a36";
        separator_color = "frame";
        corner_radius = 8;
        gap_size = 0;

        # Sorting
        sort = "yes";
        idle_threshold = 120;

        # Text
        font = "Monospace 10";
        line_height = 0;
        markup = "full";
        format = "%s %p\\n%b";
        alignment = "left";
        vertical_alignment = "center";
        show_age_threshold = 60;
        ellipsize = "middle";
        ignore_newline = "no";
        stack_duplicates = true;
        hide_duplicate_count = false;
        show_indicators = "yes";

        # Icons
        icon_position = "left";
        min_icon_size = 0;
        max_icon_size = 64;
        icon_path = "/usr/share/icons/gnome/16x16/status/:/usr/share/icons/gnome/16x16/devices/";

        # History
        sticky_history = "yes";
        history_length = 20;

        # Misc/Advanced
        dmenu = "/usr/bin/dmenu -p dunst:";
        browser = "/usr/bin/firefox -new-tab";
        always_run_script = true;
        title = "Dunst";
        class = "Dunst";
        ignore_dbusclose = false;

        # Wayland
        force_xwayland = false;

        # Legacy
        force_xinerama = false;

        # Mouse
        mouse_left_click = "close_current";
        mouse_middle_click = "do_action, close_current";
        mouse_right_click = "close_all";
      };

      experimental = {
        per_monitor_dpi = false;
      };

      urgency_low = {
        background = "#15151a";
        foreground = "#6272a4";
        timeout = 10;
      };

      urgency_normal = {
        background = "#15151a";
        foreground = "#bd93f9";
        timeout = 10;
      };

      urgency_critical = {
        background = "#ff5555";
        foreground = "#f8f8f2";
        frame_color = "#ff5555";
        timeout = 0;
      };
    };
    #   global = {
    #     follow = "mouse";
    #     width = 500;
    #     origin = "top-right";
    #     alignment = "left";
    #     vertical_alignment = "center";
    #     ellipsize = "middle";
    #     offset = "15x15";
    #     padding = 15;
    #     horizontal_padding = 15;
    #     text_icon_padding = 15;
    #     icon_position = "left";
    #     min_icon_size = 48;
    #     max_icon_size = 64;
    #     progress_bar = true;
    #     progress_bar_height = 8;
    #     progress_bar_frame_width = 1;
    #     progress_bar_min_width = 150;
    #     progress_bar_max_width = 300;
    #     separator_height = 2;
    #     frame_width = 2;
    #     frame_color = default.xcolors.color4;
    #     separator_color = "frame";
    #     corner_radius = 8;
    #     transparency = 0;
    #     gap_size = 8;
    #     line_height = 0;
    #     notification_limit = 0;
    #     idle_threshold = 120;
    #     history_length = 20;
    #     show_age_threshold = 60;
    #     markup = "full";
    #     font = "AestheticIosevka Nerd Font Mono";
    #     format = "<span size='x-large' font_desc='Iosevka Nerd Font 10' foreground='${default.xcolors.fg}'>%a</span>\\n%s\\n%b";
    #     word_wrap = "yes";
    #     sort = "yes";
    #     shrink = "no";
    #     indicate_hidden = "yes";
    #     sticky_history = "yes";
    #     ignore_newline = "no";
    #     show_indicators = "no";
    #     stack_duplicates = true;
    #     always_run_script = true;
    #     hide_duplicate_count = false;
    #     ignore_dbusclose = false;
    #     force_xwayland = false;
    #     force_xinerama = false;
    #     mouse_left_click = "do_action";
    #     mouse_middle_click = "close_all";
    #     mouse_right_click = "close_current";
    #   };
    #
    #   fullscreen_delay_everything = { fullscreen = "delay"; };
    #   logger = {
    #     summary = "*";
    #     body = "*";
    #     script = "~/.config/eww/scripts/notification_logger.zsh";
    #   };
    #   urgency_critical = {
    #     background = default.xcolors.bg;
    #     foreground = default.xcolors.fg;
    #     frame_color = default.xcolors.color4;
    #   };
    #   urgency_low = {
    #     background = default.xcolors.bg;
    #     foreground = default.xcolors.fg;
    #     frame_color = default.xcolors.color4;
    #   };
    #   urgency_normal = {
    #     background = default.xcolors.bg;
    #     foreground = default.xcolors.fg;
    #     frame_color = default.xcolors.color4;
    #   };
    # };
  };
}
