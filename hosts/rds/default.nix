{
  imports = [
    ./configuration.nix
    ./hardware-configuration.nix
    ../common
    ../common/default-linux.nix
    ../common/gui.nix
    ./vpn.nix
  ];
}
