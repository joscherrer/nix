{ self, inputs, outputs, config, pkgs, lib, ... }:
{
  imports = [
    inputs.home-manager.nixosModules.home-manager
  ];

  nix = {
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 30d";
    };
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

  i18n.defaultLocale = "en_US.UTF-8";

  security.sudo.enable = true;
  security.sudo.wheelNeedsPassword = false;

  services.locate.enable = true;

  users.defaultUserShell = pkgs.zsh;

  users.users.jscherrer = {
    initialHashedPassword = "";
    isNormalUser = true;
    group = "jscherrer";
    extraGroups = [ "wheel" ];
    createHome = true;
  };

  users.groups = {
    better-gc = { };
    jscherrer = { };
  };

  security.pam.loginLimits = [
    { domain = "*"; type = "soft"; item = "nofile"; value = "131070"; }
  ];
  systemd.user.extraConfig = "DefaultLimitNOFILE=131070";

  programs.gnupg.agent = {
    enable = true;
    # pinentryFlavor = "gnome3";
    enableSSHSupport = true;
  };
}
