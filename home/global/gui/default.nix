{
  self,
  inputs,
  outputs,
  config,
  pkgs,
  default,
  ...
}:
let
  browser = [ "firefox.desktop" ];
  notion-icon = builtins.fetchurl {
    url = "https://upload.wikimedia.org/wikipedia/commons/thumb/e/e9/Notion-logo.svg/480px-Notion-logo.svg.png";
    sha256 = "sha256:0liksflpwv14q4fqg36syaa2sbxc2nwksf0j6gpr36qaji7mnwwk";
  };
in
{
  imports = [
    ../../../modules/alacritty
    ./dunst.nix
    ./hyprland.nix
    ./rofi.nix
    # ./swayidle.nix
    # ./swaylock.nix
    ./terminal.nix
    ./vscode.nix
    ./waybar.nix
    ./thunderbird.nix
    inputs.catppuccin.homeManagerModules.catppuccin
  ];

  programs.firefox.enable = true;
  home.sessionVariables.BROWSER = "${pkgs.firefox}/bin/firefox";
  home.sessionVariables.GTK_THEME = "catppuccin-mocha-mauve-compact+normal";
  home.sessionVariables.DEFAULT_BROWSER = "${pkgs.firefox}/bin/firefox";

  catppuccin = {
    accent = "mauve";
    flavor = "mocha";
  };

  home.pointerCursor = {
    gtk.enable = true;
    x11.enable = true;
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Classic";
    size = 24;
  };

  gtk = {
    enable = true;
    font = {
      name = "Roboto";
      package = pkgs.roboto;
    };

    gtk2.configLocation = "${config.xdg.configHome}/gtk-2.0/gtkrc";

    iconTheme = {
      name = "Bibata-Modern-Classic";
      package = pkgs.bibata-cursors;
    };

    catppuccin = {
      enable = true;
      # accent = "mauve";
      # flavor = "mocha";
      size = "compact";
    };

    gtk2.extraConfig = ''
      gtk-application-prefer-dark-theme = 1
    '';
    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
    };
    gtk4.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
    };
  };

  qt = {
    style = {
      catppuccin.enable = true;
    };
  };

  # catppuccin.enable = true;

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
    "x-scheme-handler/chrome" = [ "chromium-browser.desktop" ];
    "x-scheme-handler/ftp" = browser;
    "x-scheme-handler/http" = browser;
    "x-scheme-handler/https" = browser;
    "x-scheme-handler/unknown" = browser;

    "audio/*" = [ "mpv.desktop" ];
    "video/*" = [ "mpv.dekstop" ];
    "image/*" = [ "imv.desktop" ];
    "application/json" = browser;
    "application/pdf" = [ "org.pwmt.zathura.desktop.desktop" ];
    "x-scheme-handler/discord" = [ "webcord.desktop" ];
    "x-scheme-handler/spotify" = [ "spotify.desktop" ];
    "x-scheme-handler/tg" = [ "telegramdesktop.desktop" ];
  };

  programs.wlogout = {
    enable = true;
  };

  home.packages = with pkgs; [
    qalculate-qt
    cliphist
    rofimoji
    wl-clipboard
    pavucontrol
    imv
    playerctl
    pamixer
    webcord
    discord
    vesktop
    slurp
    grim
    wf-recorder
    wtype
    zathura
    spotify
    filezilla
    libsForQt5.qtstyleplugin-kvantum
    chromium
    dbeaver-bin
    bitwarden
    telegram-desktop
    (catppuccin-kvantum.override {
      accent = "mauve";
      variant = "mocha";
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

  home.file.".local/share/applications/notion.desktop".text = ''
    [Desktop Entry]
    Name=Notion
    Exec=chromium --window-name="notion" --enable-features=UseOzonePlatform --ozone-platform=wayland https://notion.so
    Icon=${notion-icon}
    Type=Application
    Categories=Office;
  '';

  home.file.".local/share/applications/notion-calendar.desktop".text = ''
    [Desktop Entry]
    Name=Notion Calendar
    Exec=chromium --window-name="notion-calendar" --enable-features=UseOzonePlatform --ozone-platform=wayland https://calendar.notion.so
    Icon=${notion-icon}
    Type=Application
    Categories=Office;
  '';

  home.sessionVariables = {
    QT_STYLE_OVERRIDE = "kvantum";
  };

  xdg.configFile."Kvantum/kvantum.kvconfig".source =
    (pkgs.formats.ini { }).generate "kvantum.kvconfig"
      {
        General.Theme = "Catppuccin-Mocha-Mauve";
      };

  programs.obs-studio = {
    enable = true;
    package = pkgs.stable.obs-studio;
  };
}
