{ self, inputs, outputs, config, pkgs, ... }:
{
  imports = [
    ./. # hosts/common/
    ./hyprland.nix
  ];

  environment.systemPackages = with pkgs; [
    kitty
  ];

  i18n.inputMethod.enabled = "ibus";
}
