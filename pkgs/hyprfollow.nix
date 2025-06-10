{ pkgs, ... }:

pkgs.buildGoModule {
  pname = "hyprfollow";
  version = "0.1.0";
  src = ../scripts/hyprfollow;
  vendorHash = null; # Let Nix compute this for you!

  ldflags = [
    "-s"
    "-w"
  ];

  # nativeBuildInputs = [ pkgs.installShellFiles ];

  # postInstall = ''
  #   installBin $out/bin/hyprfollow
  # '';

  meta = {
    description = "A tool to follow Hyprland windows";
    mainProgam = "hyprfollow";
  };
}
