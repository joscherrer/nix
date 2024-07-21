{ inputs, lib, pkgs, config, outputs, default, ... }:
{
  services.swayidle = {
    enable = false;
    events = [
      {
        event = "before-sleep";
        command = "${pkgs.systemd}/bin/loginctl lock-session";
      }
      # {
      #   event = "lock";
      #   command = "${pkgs.swaylock-effects}/bin/swaylock -fF";
      # }
    ];
    timeouts = [
      {
        timeout = 600;
        command = "${pkgs.systemd}/bin/systemctl suspend";
      }
    ];
  };

  systemd.user.services.swayidle.Install.WantedBy = [ "hyprland-session.target" "greetd.target" ];
}
