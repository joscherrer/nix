# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{
  self,
  inputs,
  outputs,
  config,
  pkgs,
  lib,
  ...
}:
{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages_6_17;

  networking.hostName = "rds"; # Define your hostname.

  networking.networkmanager.enable = true;

  time.timeZone = "Europe/Paris";

  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "fr_FR.UTF-8";
    LC_IDENTIFICATION = "fr_FR.UTF-8";
    LC_MEASUREMENT = "fr_FR.UTF-8";
    LC_MONETARY = "fr_FR.UTF-8";
    LC_NAME = "fr_FR.UTF-8";
    LC_NUMERIC = "fr_FR.UTF-8";
    LC_PAPER = "fr_FR.UTF-8";
    LC_TELEPHONE = "fr_FR.UTF-8";
    LC_TIME = "fr_FR.UTF-8";
  };

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    users.jscherrer = import "${self}/home/jscherrer/rds.nix";
    users.root = import "${self}/home/root";
    extraSpecialArgs = { inherit inputs outputs; };
  };

  fonts.packages =
    [ ] ++ builtins.filter lib.attrsets.isDerivation (builtins.attrValues pkgs.nerd-fonts);

  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;
  services.blueman.enable = true;

  nixpkgs.config.allowUnfree = true;

  services.tlp = {
    enable = true;
  };

  environment.systemPackages = with pkgs; [
    pkgs.python311
    (pkgs.python3.withPackages (
      ps: with ps; [
        flake8
        ruamel-yaml
        requests
        toml
        types-toml
        sh
        debugpy
        pywinrm
        boto3
        botocore
        dbus-python
      ]
    ))
  ];

  services.logind = {
    settings = {
      Login = {
        # HandleLidSwitch = "suspend";
        # HandleLidSwitchExternalPower = lib.mkForce "ignore";
        HandlePowerKey = "suspend";
        HandlePowerKeyLongPress = "poweroff";
        HandleSuspendKey = "suspend";
      };
    };
  };

  system.stateVersion = "25.05"; # Did you read the comment?

}
