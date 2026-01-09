{
  inputs,
  lib,
  pkgs,
  config,
  outputs,
  ...
}:
{
  programs.ashell = {
    enable = true;
    # package = inputs.ashell.packages.${pkgs.system}.default;
    systemd = {
      enable = true;
      # target = "hyprland-session.target";
    };
    settings = {
      appearance = {
        scale_factor = 1.25;
        style = "Solid";
      };
      workspaces = {
        visibility_mode = "MonitorSpecific";
        enable_workspace_filling = true;
        max_workspaces = 10;
      };
      modules = {
        left = [ "Workspaces" ];
        center = [ "WindowTitle" ];
        right = [
          "SystemInfo"
          "Tray"
          [
            "Clock"
            "Privacy"
            "Settings"
          ]
        ];
      };
    };
  };
  services.network-manager-applet.enable = true;
  home.packages = [
    pkgs.networkmanagerapplet
  ];
}
