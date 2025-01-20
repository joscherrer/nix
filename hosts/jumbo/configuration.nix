# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

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

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelParams = [ "nvidia.NVreg_PreserveVideoMemoryAllocations=1" ];

  environment.systemPackages = with pkgs; [
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    curl
    git
  ];

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  hardware.nvidia = {
    modesetting.enable = true;
    open = false;
    powerManagement.enable = true;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.production;
  };

  networking = {
    firewall = {
      allowedUDPPorts = [ 51820 ];
    };
    wireguard.enable = true;
    wireguard.interfaces = {
      wg0 = {
        ips = [ "192.168.27.68/32" ];
        listenPort = 51820;
        privateKeyFile = "/home/jscherrer/.config/wireguard/privatekey";
        peers = [
          {
            publicKey = "kPDTM5DF/IzZ3h8Akd4mE20utzaKsbxmk9UEtI+SPi0=";
            allowedIPs = [
              "192.168.27.64/27"
              "192.168.1.0/24"
            ];
            endpoint = "82.66.46.243:30195";
            persistentKeepalive = 25;
          }
        ];
      };
    };
    defaultGateway = "192.168.14.1";
    interfaces = {
      enp4s0 = {
        ipv4.addresses = [
          {
            address = "192.168.14.15";
            prefixLength = 24;
          }
        ];
      };
    };
  };

  environment.sessionVariables = {
    # LIBVA_DRIVER_NAME = "nvidia";
    # GBM_BACKEND = "nvidia-drm";
    NIXOS_OZONE_WL = "1";
    WLR_NO_HARDWARE_CURSORS = "1";
    # __GLX_VENDOR_LIBRARY_NAME = "nvidia";
  };

  services.xserver.videoDrivers = [ "nvidia" ];

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    users.jscherrer = import "${self}/home/jscherrer/jumbo.nix";
    extraSpecialArgs = {
      inherit inputs outputs;
    };
  };

  fonts.packages =
    [ ]
    ++ builtins.filter lib.attrsets.isDerivation (builtins.attrValues pkgs.nerd-fonts);

  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;
  services.blueman.enable = true;

  system.stateVersion = "24.11"; # Did you read the comment?

}
