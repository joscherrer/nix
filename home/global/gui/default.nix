{
  self,
  inputs,
  outputs,
  config,
  pkgs,
  default,
  lib,
  ...
}:
let
  browser = [ "zen.desktop" ];
  notion-icon = builtins.fetchurl {
    url = "https://upload.wikimedia.org/wikipedia/commons/thumb/e/e9/Notion-logo.svg/480px-Notion-logo.svg.png";
    sha256 = "sha256:0liksflpwv14q4fqg36syaa2sbxc2nwksf0j6gpr36qaji7mnwwk";
  };
in
{
  imports = [
    ./dunst.nix
    ./hyprland.nix
    ./rofi.nix
    # ./swayidle.nix
    # ./swaylock.nix
    ./terminal.nix
    ./vscode.nix
    ./waybar.nix
    ./thunderbird.nix
    ./nvim-remote.nix
    ./wayland-ashell.nix
    inputs.catppuccin.homeModules.catppuccin
    inputs.self.homeModules.hyprfollow
    inputs.vicinae.homeManagerModules.default
  ];

  programs.firefox.enable = true;
  home.sessionVariables.BROWSER = "${pkgs.firefox}/bin/firefox";
  home.sessionVariables.DEFAULT_BROWSER = "${pkgs.firefox}/bin/firefox";
  home.sessionVariables.GTK_THEME = "rose-pine";

  catppuccin = {
    accent = "mauve";
    flavor = "mocha";
    kvantum = {
      enable = true;
    };
    # gtk = {
    #   enable = true;
    # };
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
    theme = {
      name = "rose-pine";
      package = pkgs.rose-pine-gtk-theme;
    };
    font = {
      name = "Roboto";
      package = pkgs.roboto;
    };

    gtk2.configLocation = "${config.xdg.configHome}/gtk-2.0/gtkrc";

    iconTheme = {
      name = "Bibata-Modern-Classic";
      package = pkgs.bibata-cursors;
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

  # qt = {
  #   style = {
  #     catppuccin.enable = true;
  #   };
  # };

  # catppuccin.enable = true;

  # dconf = {
  #   enable = true;
  #   settings = {
  #     "org/gnome/desktop/interface" = {
  #       color-scheme = "prefer-dark";
  #       gtk-theme = "catppuccin-mocha-mauve-compact+normal";
  #     };
  #   };
  # };

  xdg.mimeApps.enable = true;
  xdg.mimeApps.defaultApplications = {
    "application/x-extension-htm" = lib.mkDefault browser;
    "application/x-extension-html" = lib.mkDefault browser;
    "application/x-extension-shtml" = lib.mkDefault browser;
    "application/x-extension-xht" = lib.mkDefault browser;
    "application/x-extension-xhtml" = lib.mkDefault browser;
    "application/xhtml+xml" = lib.mkDefault browser;
    "text/html" = lib.mkDefault browser;
    "x-scheme-handler/about" = lib.mkDefault browser;
    "x-scheme-handler/ftp" = lib.mkDefault browser;
    "x-scheme-handler/http" = lib.mkDefault browser;
    "x-scheme-handler/https" = lib.mkDefault browser;
    "x-scheme-handler/unknown" = lib.mkDefault browser;
    "application/json" = lib.mkDefault browser;
    "x-scheme-handler/chrome" = [ "chromium-browser.desktop" ];
    "audio/*" = [ "mpv.desktop" ];
    "video/*" = [ "mpv.dekstop" ];
    "image/*" = [ "imv.desktop" ];
    "application/pdf" = [ "org.pwmt.zathura.desktop" ];
    "x-scheme-handler/discord" = [ "webcord.desktop" ];
    "x-scheme-handler/spotify" = [ "spotify.desktop" ];
    "x-scheme-handler/tg" = [ "telegramdesktop.desktop" ];
    "application/gzip" = [ "org.kde.ark.desktop" ];
    "application/zip" = [ "org.kde.ark.desktop" ];
  };

  programs.wlogout = {
    enable = true;
    layout = [
      {
        label = "lock";
        action = "loginctl lock-session";
        text = "Lock";
        keybind = "l";
      }

      {
        label = "hibernate";
        action = "systemctl hibernate";
        text = "Hibernate";
        keybind = "h";
      }

      {
        label = "logout";
        action = "loginctl terminate-user $USER";
        text = "Logout";
        keybind = "e";
      }

      {
        label = "shutdown";
        action = "systemctl poweroff";
        text = "Shutdown";
        keybind = "s";
      }

      {
        label = "suspend";
        action = "systemctl suspend";
        text = "Suspend";
        keybind = "u";
      }

      {
        label = "reboot";
        action = "systemctl reboot";
        text = "Reboot";
        keybind = "r";
      }
    ];
  };

  home.packages =
    with pkgs;
    [
      qalculate-qt
      cliphist
      rofimoji
      wl-clipboard
      pavucontrol
      imv
      playerctl
      pamixer
      # webcord
      vesktop
      slurp
      grim
      wf-recorder
      wtype
      zathura
      filezilla
      libsForQt5.qtstyleplugin-kvantum
      chromium
      dbeaver-bin
      bitwarden-desktop
      telegram-desktop
      pandoc
      rose-pine-gtk-theme
      (catppuccin-kvantum.override {
        accent = "mauve";
        variant = "mocha";
      })
      hyprfollow
      uwsm
    ]
    ++ lib.optionals stdenv.isx86_64 [
      spotify
      discord
      google-chrome
    ];

  services.hyprfollow = {
    enable = false;
    package = pkgs.hyprfollow;
    systemdTarget = "hyprland-session.target";
  };

  services.vicinae = {
    enable = true;
    systemd = {
      enable = false;
      environment = {
        USE_LAYER_SHELL = 1;
      };
    };
    package = pkgs.vicinae;
    extensions = [
      inputs.vicinae-extensions.packages.${pkgs.stdenv.hostPlatform.system}.nix
    ];
    # extensions = [
    #   (inputs.vicinae.packages.${pkgs.stdenv.hostPlatform.system}.mkVicinaeExtension {
    #     pname = "nix";
    #     src =
    #       pkgs.fetchFromGitHub {
    #         owner = "vicinaehq";
    #         repo = "extensions";
    #         rev = "main";
    #         sha256 = "sha256-jhlWZ6WfFBjS7CXbUOreZ2zEnYiVYfeqKOaZguFFslA=";
    #       }
    #       + "extensions/nix";
    #   })
    # ];
    settings = {
      closeOnFocusLoss = true;
      considerPreedit = false;
      faviconService = "twenty";
      font = {
        size = 10.5;
      };
      keybinding = "default";
      popToRootOnClose = true;
      rootSearch = {
        searchFiles = false;
      };
      theme = {
        name = "vicinae-dark";
      };
      window = {
        csd = true;
        opacity = 0.90;
        rounding = 15;
      };
    };
  };

  # programs.vicinae = {
  #   enable = true;
  #   settings = {
  #     closeOnFocusLoss = true;
  #     considerPreedit = false;
  #     faviconService = "twenty";
  #     font = {
  #       size = 10.5;
  #     };
  #     keybinding = "default";
  #     popToRootOnClose = true;
  #     rootSearch = {
  #       searchFiles = false;
  #     };
  #     theme = {
  #       name = "vicinae-dark";
  #     };
  #     window = {
  #       csd = true;
  #       opacity = 0.98;
  #       rounding = 10;
  #     };
  #   };
  # };

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
