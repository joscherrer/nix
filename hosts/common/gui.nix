{
  self,
  lib,
  inputs,
  outputs,
  config,
  pkgs,
  ...
}:
{
  imports = [
    ./. # hosts/common/
    ./hyprland.nix
    ./vscode.nix
    ./sound.nix
    ../../lib
  ];

  environment.systemPackages = with pkgs; [
    kitty
    kdePackages.ark
    evince
    # kdePackages.dolphin
    # kdePackages.dolphin-plugins
    # kdePackages.kdf
    # kdePackages.kio
    # kdePackages.kio-fuse
    # kdePackages.kio-extras
    # kdePackages.kio-admin
    # kdePackages.kservice
    # kdePackages.qtwayland
    # shared-mime-info

  ];

  xdg.menus.enable = true;
  xdg.mime.enable = true;

  i18n.inputMethod = {
    enable = true;
    type = "ibus";
  };

  virtualisation.virtualbox = {
    host = {
      enable = true;
    };
  };

  programs.xfconf.enable = true;
  services.gvfs.enable = true;
  services.tumbler.enable = true;
  programs.thunar = {
    enable = true;
    plugins = with pkgs; [
      thunar-archive-plugin
      thunar-volman
    ];
  };

  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };

  services.printing = {
    enable = true;
    drivers = with pkgs; [
      cups-filters
      cups-browsed
    ];
  };

  security.pam.services.hyprlock = { };

  # security.pam.services.swaylock = {
  #   text = "auth include login";
  # };
}
