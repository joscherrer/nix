{ self, inputs, outputs, config, pkgs, ... }:
let
  better-gc = pkgs.writeShellScriptBin "better-gc" (builtins.readFile "${self}/scripts/better-gc");
in
{
  networking = {
    firewall.enable = true;
    networkmanager.enable = true;
  };

  virtualisation.podman = {
    enable = true;
    dockerSocket.enable = true;
  };

  i18n.defaultLocale = "en_US.UTF-8";

  security.sudo.enable = true;
  security.sudo.extraRules = [
    {
      groups = [ "wheel" ];
      commands = [
        {
          command = "ALL";
          options = [ "NOPASSWD" ];
        }
      ];
    }
    {
      users = [ "better-gc" ];
      commands = [
        {
          command = "${better-gc}/bin/better-gc";
          options = [ "NOPASSWD" ];
        }
      ];
    }
  ];

  services.openssh.enable = true;
  system.copySystemConfiguration = false;

  systemd.timers."better-gc" = {
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnBootSec = "5m";
      OnUnitActiveSec = "5h";
      Unit = "better-gc.service";
    };
  };

  systemd.services."better-gc" = {
    path = [ pkgs.bash pkgs.nix ];
    serviceConfig = {
      Type = "oneshot";
      User = "better-gc";
      ExecStart = "/run/wrappers/bin/sudo ${better-gc}/bin/better-gc";
    };
  };

  users.defaultUserShell = pkgs.zsh;

  users.users.jscherrer = {
    initialHashedPassword = "";
    isNormalUser = true;
    group = "jscherrer";
    extraGroups = [ "wheel" "networkmanager" ];
    createHome = true;
  };

  users.users.better-gc = {
    group = "better-gc";
    shell = "/dev/null";
    isSystemUser = true;
  };

  users.groups = {
    better-gc = { };
    jscherrer = { };
  };

  environment.systemPackages = with pkgs; [
    sudo
  ];
}
