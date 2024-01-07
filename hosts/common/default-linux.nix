{ self, inputs, outputs, config, pkgs, lib, ... }:
let
  better-gc = pkgs.writeShellScriptBin "better-gc" (builtins.readFile "${self}/scripts/better-gc");
in
{
  imports = [
    inputs.home-manager.nixosModules.home-manager
  ];

  networking = {
    firewall = {
      enable = true;
      trustedInterfaces = [ "kind" "kindrl" "kindrf" "podman0" "podman1" "enp39s0" ];
    };
    networkmanager.enable = true;
  };

  virtualisation.podman = {
    enable = true;
    dockerSocket.enable = true;
  };
  virtualisation.containers = {
    enable = true;
    registries.search = ["registry.access.redhat.com" "docker.io" "quay.io" "ghcr.io"];
    # registries.insecure = ["cr.dns.podman" "cr.dns.podman:5000" "kind-cr.dns.podman:5000" "localhost:5000"];
  };

  virtualisation.libvirtd.enable = true;
  programs.dconf.enable = true;

  i18n.defaultLocale = "en_US.UTF-8";

  security.sudo.enable = true;
  security.sudo.wheelNeedsPassword = false;

  security.sudo.extraRules = [
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
  services.locate.enable = true;

  systemd.timers."better-gc" = {
    enable = false;
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
    extraGroups = [ "wheel" "networkmanager" "libvirtd" "podman" ];
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

  security.pam.loginLimits = [
    { domain = "*"; type = "soft"; item = "nofile"; value = "131070"; }
  ];
  systemd.user.extraConfig = "DefaultLimitNOFILE=131070";
}
