{ self, inputs, outputs, config, pkgs, ... }:
let
  better-gc = pkgs.writeShellScriptBin "better-gc" (builtins.readFile "${self}/scripts/better-gc");
in
{
  imports = [
    inputs.home-manager.nixosModules.home-manager
  ];

  home-manager = {
    useUserPackages = true;
    useGlobalPkgs = true;
    users.jscherrer = import "${self}/home/jscherrer/${config.networking.hostName}.nix";
    extraSpecialArgs = { inherit inputs outputs; };
  };

  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.systemd-boot.enable = true;

  environment.pathsToLink = [ "/share/zsh" ];
  environment.systemPackages = with pkgs; [
    sudo
    vim
    neovim
    curl
    wget
    python3
    pypy3
    pciutils
    git
  ];

  i18n.defaultLocale = "en_US.UTF-8";

  networking = {
    networkmanager.enable = true;
    firewall.enable = false;
  };

  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
  };

  nixpkgs.config.allowUnfree = true;
  nixpkgs.overlays = builtins.attrValues outputs.overlays;

  virtualisation.podman = {
    enable = true;
    dockerSocket.enable = true;
  };

  programs = {
    tmux.enable = true;
    zsh.enable = true;
    git.enable = true;
  };

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
  system.stateVersion = "22.11"; # Did you read the comment?

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

  time.timeZone = "Europe/Paris";

  users.defaultUserShell = pkgs.zsh;

  users.users.jscherrer = {
    isNormalUser = true;
    group = "jscherrer";
    extraGroups = [ "wheel" "networkmanager" ];
    createHome = true;
    initialHashedPassword = "";
    openssh.authorizedKeys.keys =
      let
        authorizedKeys = pkgs.fetchurl {
          url = "https://github.com/joscherrer.keys";
          hash = "sha256-gWAWZKicQVi9H4xCGiMQHauiUN34CBMYhJgBem5qunI=";
        };
      in
      pkgs.lib.splitString "\n" (builtins.readFile authorizedKeys);
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
}
