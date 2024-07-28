{ self, lib, inputs, outputs, config, pkgs, ... }:
{
  imports = [
    ./. # hosts/common/
    ./hyprland.nix
    ./vscode.nix
    ./sound.nix
    ../../lib
  ];

  environment.systemPackages = with pkgs; [
    kitty
  ];

  i18n.inputMethod = {
    enable = true;
    type = "ibus";
  };

  security.pam.services.swaylock = {
    text = "auth include login";
  };
}
