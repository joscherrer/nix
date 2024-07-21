{ inputs, lib, pkgs, config, outputs, ... }:
{
  imports = [
    ./go.nix
    ./java.nix
    ./js.nix
  ];
}
