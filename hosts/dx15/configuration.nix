{ inputs, outputs, config, pkgs, lib, ... }:
{
  imports = [
    ./hardware-configuration.nix
    inputs.nixos-hardware.nixosModules.dell-xps-15-9560
  ];

  networking.hostName = "dx15";

  environment.sessionVariables = {
    LIBVA_DRIVER_NAME = "nvidia";
    GBM_BACKEND = "nvidia-drm";
    WLR_NO_HARDWARE_CURSORS = "1";
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
  };
}
