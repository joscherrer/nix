{ inputs, config, pkgs, lib, ... }:
{
  imports = [
    ../global
    ../global/gui.nix
  ];

  # Needed to fix non-working dead-keys
  # https://youtrack.jetbrains.com/issue/IDEA-291887/US-international-keyboard-layout-with-dead-keys-not-working-properly-no-or-or-German-Umlaute
  xdg.desktopEntries = {
    idea-community = {
      categories = [ "Development" ];
      name = "IntelliJ IDEA CE";
      genericName = "Integrated Development Environment (IDE) by Jetbrains, community edition";
      exec = "env XMODIFIERS=\"\" idea-community";
      type = "Application";
      icon = "idea-community";
      comment = "IDE for Java SE, Groovy & Scala development Powerful environment for building Google Android apps Integration with JUnit, TestNG, popular SCMs, Ant & Maven. Also known as IntelliJ.";
      settings = {
        StartupWMClass = "jetbrains-idea-ce";
        Version = "1.4";
      };
    };
  };
  home.username = lib.mkDefault "jscherrer";
  home.homeDirectory = lib.mkDefault "/home/jscherrer";

  programs.keychain.enable = true;
  services.gnome-keyring.enable = true;

  xdg.mimeApps.enable = true;
  xdg.mimeApps.defaultApplications = {
    "text/html" = "firefox.desktop";
    "x-scheme-handler/http" = "firefox.desktop";
    "x-scheme-handler/https" = "firefox.desktop";
    "x-scheme-handler/about" = "firefox.desktop";
    "x-scheme-handler/unknown" = "firefox.desktop";
  };
  home.packages = [
    pkgs.kanshi
  ];

  services.kanshi.enable = true;
  services.kanshi.systemdTarget = "hyprland-session.target";
  services.kanshi.profiles = {
    connected = {
      outputs = [
        {
          criteria = "LG Electronics LG HDR WQHD+ 205NTCZ8L675";
          mode = "3840x1600@120Hz";
          position = "1920,0";
          status = "enable";
        }
        {
          criteria = "Dell Inc. DELL U2415 7MT0167B2YNL";
          mode = "1920x1200";
          position = "0,200";
          status = "enable";
        }
        {
          criteria = "AOC 28E850 Unknown";
          mode = "1920x1200";
          position = "0,0";
          status = "enable";
        }
      ];
    };
    disconnected = {
      outputs = [
        {
          criteria = "AOC 28E850 Unknown";
          mode = "1920x1200";
          position = "0,0";
          status = "enable";
        }
      ];
    };
  };

  # home.file.".config/kanshi/config" = ''
  #   output eDP-1
  #     mode 1920x1080
  #     position 0,0
  #     scale 1
  #   output DP-1
  #     mode 1920x1080
  #     position 1920,0
  #     scale 1
  # '';
}
