{ inputs, outputs, config, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
      inputs.hyprland.nixosModules.default
    ];

  programs.hyprland.enable = true;
  programs.hyprland.xwayland = {
    enable = true;
    hidpi = true;
  };

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;


  networking = {
    hostName = "dx15";
    networkmanager.enable = true;
    firewall.enable = false;
  };

  time.timeZone = "Europe/Paris";

  users.users.jscherrer = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" ];
    createHome = true;
    initialHashedPassword = "";
    packages = with pkgs; [ neovim ];
    openssh.authorizedKeys.keys =
      let
        authorizedKeys = pkgs.fetchurl {
          url = "https://github.com/joscherrer.keys";
          hash = "sha256-gWAWZKicQVi9H4xCGiMQHauiUN34CBMYhJgBem5qunI=";
        };
      in
      pkgs.lib.splitString "\n" (builtins.readFile authorizedKeys);
  };

  services.openssh.enable = true;

  i18n.defaultLocale = "en_US.UTF-8";

  # Enable sound.
  # sound.enable = true;
  # hardware.pulseaudio.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  environment.systemPackages = with pkgs; [
    vim
    neovim
    curl
    wget
    python3
    pypy3
    alacritty
    kitty
    pciutils
    glxinfo
    git
  ];

  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
  };
  system.copySystemConfiguration = false;
  system.stateVersion = "22.11"; # Did you read the comment?

  security.sudo.extraRules = [
    {
      groups = [ "wheel" ];
      commands = [
        {
          command = "ALL";
          options = [ "NOPASSWD" ];
        }
      ];
    }
  ];
}
