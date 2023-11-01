{ self, inputs, outputs, config, pkgs, default, ... }:
let
  browser = ["firefox.desktop"];
in
{
  imports = [
    ../../modules/alacritty
    ./hyprland.nix
    ./waybar.nix
    ./rofi.nix
    ./vscode.nix
    ./swaylock.nix
    ./swayidle.nix
    ./dunst.nix
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

  dconf = {
    enable = true;
    settings = {
      "org/gnome/desktop/interface" = {
        color-scheme = "prefer-dark";
      };
    };
  };

  xdg.mimeApps.enable = true;
  xdg.mimeApps.defaultApplications = {
    "application/x-extension-htm" = browser;
    "application/x-extension-html" = browser;
    "application/x-extension-shtml" = browser;
    "application/x-extension-xht" = browser;
    "application/x-extension-xhtml" = browser;
    "application/xhtml+xml" = browser;
    "text/html" = browser;
    "x-scheme-handler/about" = browser;
    "x-scheme-handler/chrome" = ["chromium-browser.desktop"];
    "x-scheme-handler/ftp" = browser;
    "x-scheme-handler/http" = browser;
    "x-scheme-handler/https" = browser;
    "x-scheme-handler/unknown" = browser;

    "audio/*" = ["mpv.desktop"];
    "video/*" = ["mpv.dekstop"];
    "image/*" = ["imv.desktop"];
    "application/json" = browser;
    "application/pdf" = ["org.pwmt.zathura.desktop.desktop"];
    "x-scheme-handler/discord" = ["webcord.desktop"];
    "x-scheme-handler/spotify" = ["spotify.desktop"];
    "x-scheme-handler/tg" = ["telegramdesktop.desktop"];
  };


  home.packages = with pkgs; [
    wlogout
    cliphist
    wl-clipboard
    pavucontrol
    imv
    playerctl
    pamixer
    webcord
    slurp
    grim
    wf-recorder
    zathura
    spotify
    libsForQt5.qtstyleplugin-kvantum
    (catppuccin-kvantum.override {
      accent = "Mauve";
      variant = "Mocha";
    })
  ];

  programs.mpv = {
    enable = true;
  };

  services = {
    playerctld.enable = true;
  };

  # home.file.".local/share/applications/discord.desktop".text = ''
  #   [Desktop Entry]
  #   Categories=Network;InstantMessaging
  #   Exec=Discord --enable-features=UseOzonePlatform --ozone-platform=wayland 
  #   GenericName=All-in-one cross-platform voice and text chat for gamers
  #   Icon=discord
  #   MimeType=x-scheme-handler/discord
  #   Name=Discord
  #   Type=Application
  #   Version=1.4
  # '';

  home.file.".local/share/applications/spotify.desktop".text = ''
    [Desktop Entry]
    Type=Application
    Name=Spotify
    GenericName=Music Player
    Icon=spotify-client
    TryExec=spotify
    Exec=spotify %U --enable-features=UseOzonePlatform --ozone-platform=wayland
    Terminal=false
    MimeType=x-scheme-handler/spotify;
    Categories=Audio;Music;Player;AudioVideo;
    StartupWMClass=spotify
  '';

  home.sessionVariables = { QT_STYLE_OVERRIDE = "kvantum"; };

  xdg.configFile."Kvantum/kvantum.kvconfig".source =
    (pkgs.formats.ini { }).generate "kvantum.kvconfig" {
      General.Theme = "Catppuccin-Mocha-Mauve";
    };

  programs.obs-studio = {
    enable = true;
    package = pkgs.stable.obs-studio;
  };
}
