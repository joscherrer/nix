{ inputs, config, pkgs, lib, ... }:
{
  imports = [
    ../global
    ../global/gui.nix
    ../global/terminal.nix
  ];

  # Needed to fix non-working dead-keys
  # https://youtrack.jetbrains.com/issue/IDEA-291887/US-international-keyboard-layout-with-dead-keys-not-working-properly-no-or-or-German-Umlaute
  # xdg.desktopEntries = {
  #   idea-community = {
  #     categories = [ "Development" ];
  #     name = "IntelliJ IDEA CE";
  #     genericName = "Integrated Development Environment (IDE) by Jetbrains, community edition";
  #     exec = "env XMODIFIERS=\"\" idea-community";
  #     type = "Application";
  #     icon = "idea-community";
  #     comment = "IDE for Java SE, Groovy & Scala development Powerful environment for building Google Android apps Integration with JUnit, TestNG, popular SCMs, Ant & Maven. Also known as IntelliJ.";
  #     settings = {
  #       StartupWMClass = "jetbrains-idea-ce";
  #       Version = "1.4";
  #     };
  #   };
  # };
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
    pkgs.buildah
    pkgs.pdm
    pkgs.vagrant
    pkgs.obsidian
  ];

  services.kanshi.enable = false;
  # services.kanshi.systemdTarget = "hyprland-session.target";
  services.kanshi.profiles = {
    connected = {
      # exec = [
      #   "hyprctl dispatch movecursor 3840 800"
      #   "hyprctl dispatch moveworkspacetomonitor '1 DP-1'"
      #   "hyprctl dispatch moveworkspacetomonitor '3 DP-1'"
      #   "hyprctl dispatch moveworkspacetomonitor '5 DP-1'"
      #   "hyprctl dispatch moveworkspacetomonitor '7 DP-1'"
      #   "hyprctl dispatch moveworkspacetomonitor '9 DP-1'"
      #   "hyprctl dispatch moveworkspacetomonitor '2 DP-2'"
      #   "hyprctl dispatch moveworkspacetomonitor '4 DP-2'"
      #   "hyprctl dispatch moveworkspacetomonitor '6 DP-2'"
      #   "hyprctl dispatch moveworkspacetomonitor '8 DP-2'"
      #   "hyprctl dispatch moveworkspacetomonitor '10 DP-2'"
      # ];
      outputs = [
        {
          criteria = "LG Electronics LG HDR WQHD+ 205NTCZ8L675";
          mode = "3840x1600@143.998001Hz";
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
          position = "6000,0";
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
}
