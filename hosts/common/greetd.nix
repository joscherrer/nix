{
  inputs,
  lib,
  config,
  pkgs,
  default,
  ...
}:
let
  hyprland = config.programs.hyprland.package;
  regreet = config.services.displayManager.regreet.package;

  # Same base as the user session (home/global/gui/hyprland.nix): monitors,
  # input and cursor/GPU env, plus the host's monitor layout if it has one.
  hyprDir = "${inputs.self}/dotfiles/common/.config/hypr";
  hostLua = "${inputs.self}/dotfiles/hosts/${config.networking.hostName}/hypr/host.lua";

  greeterConfig = pkgs.writeText "greeter-hyprland.lua" ''
    package.path = "/etc/greetd/hypr/?.lua;/etc/greetd/hypr/?/init.lua;" .. package.path
    require("base")

    hl.config({
        misc = {
            disable_hyprland_logo = true,
            disable_splash_rendering = true,
        },
        animations = {
            enabled = false,
        },
    })

    -- Escape hatch if regreet hangs.
    hl.bind("SUPER + M", hl.dsp.exit())

    hl.on("hyprland.start", function()
        hl.exec_cmd("systemd-cat --identifier=regreet ${regreet}/bin/regreet; ${hyprland}/bin/hyprctl dispatch 'hl.dsp.exit()'")
    end)
  '';

  hyprland-greeter = pkgs.writeShellScriptBin "hyprland-greeter" ''
    exec ${hyprland}/bin/start-hyprland -- --config /etc/greetd/hypr/hyprland.lua
  '';
in
{
  # Disabled by default; hosts opt in with lib.mkForce true (see rds,
  # bbrain-linux).
  services.greetd = {
    enable = false;
    settings = {
      default_session = {
        command = "${hyprland-greeter}/bin/hyprland-greeter";
        user = "greeter";
      };
    };
  };

  services.displayManager.regreet.enable = false;
  services.displayManager.regreet.settings = {
    background = {
      path = "${default.wallpaper}";
      fit = "Cover";
    };
    GTK = {
      theme_name = lib.mkForce "Catppuccin-Mocha-Compact-Mauve-Dark";
      application_prefer_dark_theme = true;
    };
  };

  environment.systemPackages = [
    hyprland-greeter
    pkgs.fluent-gtk-theme
  ];

  environment.etc = {
    "greetd/hypr/hyprland.lua".source = greeterConfig;
    "greetd/hypr/base".source = "${hyprDir}/base";
  }
  // lib.optionalAttrs (builtins.pathExists hostLua) {
    "greetd/hypr/host.lua".source = hostLua;
  };
}
