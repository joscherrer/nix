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
}
