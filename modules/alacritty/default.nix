{ lib, config, ...}:
{
  programs.alacritty.enable = true;
  programs.alacritty.settings = {
    draw_bold_text_with_bright_colors = true;
    font = {
      normal = {
        family = lib.mkDefault "CaskaydiaCove Nerd Font";
        style = "Regular";
      };
      bold = {
        family = lib.mkDefault "CaskaydiaCove Nerd Font";
        style = "Bold";
      };
      italic = {
        family = lib.mkDefault "CaskaydiaCove Nerd Font";
        style = "Italic";
      };
      bold_italic = {
        family = lib.mkDefault "CaskaydiaCove Nerd Font";
        style = "Bold Italic";
      };
      size = 16.0;
    };
    theme = "Snazzy";
    window = {
      opacity = 1;
      dynamic_padding = false;
      padding = {
        x = 5;
        y = 5;
      };
    };

    colors = {
      primary = {
        background = "#282a36";
        foreground = "#eff0eb";
      };
      normal = {
        black = "#282a36";
        red = "#ff5c57";
        green = "#5af78e";
        yellow = "#f3f99d";
        blue = "#57c7ff";
        magenta = "#ff6ac1";
        cyan = "#9aedfe";
        white = "#f1f1f0";
      };
      bright = {
        black = "#686868";
        red = "#ff5c57";
        green = "#5af78e";
        yellow = "#f3f99d";
        blue = "#57c7ff";
        magenta = "#ff6ac1";
        cyan = "#9aedfe";
        white = "#f1f1f0";
      };
    };
  };
}