{ inputs, config, pkgs, lib, ... }:
{
  programs.kitty = {
    enable = true;
    themeFile = "snazzy";
    font.name = "CaskaydiaCove Nerd Font";
    font.size = 13;
    settings = {
        clear_all_shortcuts = "yes";
    };
    keybindings = {
        "ctrl+shift+v" = "paste_from_clipboard";
        "ctrl+shift+c" = "copy_to_clipboard";
        "ctrl+shift+equal" = "change_font_size all +2.0";
        "ctrl+shift+plus" = "change_font_size all +2.0";
        "ctrl+shift+minus" = "change_font_size all -2.0";
        "cmd+plus" = "change_font_size all +2.0";
        "cmd+minus" = "change_font_size all -2.0";
        "ctrl+shift+backspace" = "change_font_size all 0";
        "cmd+0" = "change_font_size all 0";
        "ctrl+shift+f11" = "toggle_fullscreen";
        "ctrl+cmd+f" = "toggle_fullscreen";
        "ctrl+shift+u" = "kitten unicode_input";
        "ctrl+shift+f5" = "load_config_file";
        "ctrl+shift+f6" = "debug_config";
    };
  };
}
