{ inputs, outputs, config, pkgs, lib, ... }:
{
  imports = [
    ./hardware-configuration.nix
  ];

  networking.hostName = "dx15-qemu";
  # services.qemuGuest.enable = true;
}
