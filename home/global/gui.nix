{ self, inputs, outputs, config, pkgs, default, ... }:
{
  imports = [
    ../../modules/alacritty
    ./hyprland.nix
    ./waybar.nix
    ./rofi.nix
    ./vscode.nix
    ./swaylock.nix
    ./swayidle.nix
  ];

  programs.firefox.enable = true;
  home.sessionVariables.BROWSER = "${pkgs.firefox}/bin/firefox";
  home.sessionVariables.DEFAULT_BROWSER = "${pkgs.firefox}/bin/firefox";
  programs.swaylock.enable = true;

  gtk = {
    enable = true;
    font = {
      name = "Roboto";
      package = pkgs.roboto;
    };

    gtk2.configLocation = "${config.xdg.configHome}/gtk-2.0/gtkrc";

    iconTheme = {
      name = "WhiteSur";
      package = pkgs.whitesur-icon-theme;
    };

    theme = {
      name = "Catppuccin-Mocha-Compact-Mauve-dark";
      package = pkgs.catppuccin-gtk.override {
        accents = [ "mauve" ];
        size = "compact";
        variant = "mocha";
      };
    };

    gtk3.extraConfig = { gtk-application-prefer-dark-theme = 1; };

    gtk4.extraConfig = { gtk-application-prefer-dark-theme = 1; };
  };

  home.packages = with pkgs; [
    wlogout
    libsForQt5.qtstyleplugin-kvantum
    (catppuccin-kvantum.override {
      accent = "Mauve";
      variant = "Mocha";
    })
  ];
  home.sessionVariables = { QT_STYLE_OVERRIDE = "kvantum"; };

  xdg.configFile."Kvantum/kvantum.kvconfig".source =
    (pkgs.formats.ini { }).generate "kvantum.kvconfig" {
      General.Theme = "Catppuccin-Mocha-Mauve";
    };
}
