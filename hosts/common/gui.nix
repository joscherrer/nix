{ self, inputs, outputs, config, pkgs, ... }:
{
  imports = [
    ./. # hosts/common/
    ./hyprland.nix
    ./vscode.nix
    ./sound.nix
  ];

  environment.systemPackages = with pkgs; [
    kitty
  ];

  i18n.inputMethod.enabled = "ibus";
}
