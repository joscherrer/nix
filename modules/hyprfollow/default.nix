{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.hyprfollow;
in
{
  options.services.hyprfollow = {
    enable = lib.mkEnableOption "hyprfollow user service";
    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.hyprfollow;
      description = "The hyprfollow package to use.";
    };
    systemdTarget = lib.mkOption {
      type = lib.types.str;
      default = config.wayland.systemd.target;
      defaultText = lib.literalExpression "config.wayland.systemd.target";
      example = "hyprland-session.target";
      description = "Systemd target to bind to.";
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.user.services.hyprfollow = lib.mkIf (cfg.package != null) {
      Install = {
        WantedBy = [ cfg.systemdTarget ];
      };

      Unit = {
        ConditionEnvironment = "WAYLAND_DISPLAY";
        Description = "hyprfollow user service";
        After = [ cfg.systemdTarget ];
        PartOf = [ cfg.systemdTarget ];
      };

      Service = {
        ExecStart = "${lib.getExe cfg.package}";
        Restart = "always";
        RestartSec = "10";
      };
    };
  };
}
