{ self, inputs, outputs, config, pkgs, lib, ... }:
{
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  environment.systemPackages = [
    pkgs.unstable.jetbrains.jdk
    pkgs.unstable.jetbrains.gateway
    pkgs.unstable.jetbrains.idea-community
  ];

  fonts.packages = [
    pkgs.nerdfonts
  ];

  nixpkgs.config.allowUnfree = true;

  networking.hostName = "bbrain-linux"; # Define your hostname.
  networking.networkmanager.enable = true;
  networking.interfaces.enp39s0.wakeOnLan.enable = true;
  #networking.bridges = {
  #  "br0" = {
  #    interfaces = [
  #      "enp39s0"
  #    ];
  #  };
  #};

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "fr_FR.UTF-8";
    LC_IDENTIFICATION = "fr_FR.UTF-8";
    LC_MEASUREMENT = "fr_FR.UTF-8";
    LC_MONETARY = "fr_FR.UTF-8";
    LC_NAME = "fr_FR.UTF-8";
    LC_NUMERIC = "fr_FR.UTF-8";
    LC_PAPER = "fr_FR.UTF-8";
    LC_TELEPHONE = "fr_FR.UTF-8";
    LC_TIME = "fr_FR.UTF-8";
  };

  services.xserver = {
    layout = "us";
    xkbVariant = "intl";
  };

  console.keyMap = "us-acentos";

  users.users.jscherrer = {
    isNormalUser = true;
    description = "Jonathan Scherrer";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [ ];
  };

  system.stateVersion = "23.05"; # Did you read the comment?

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    users.jscherrer = import "${self}/home/jscherrer/bbrain-linux.nix";
    extraSpecialArgs = { inherit inputs outputs; };
  };

  programs.hyprland.enableNvidiaPatches = true;

  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
  };

  hardware.nvidia = {
    modesetting.enable = true;
    open = false;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.production;
  };

  environment.sessionVariables = {
    # LIBVA_DRIVER_NAME = "nvidia";
    # GBM_BACKEND = "nvidia-drm";
    WLR_NO_HARDWARE_CURSORS = "1";
    # __GLX_VENDOR_LIBRARY_NAME = "nvidia";
  };

  # Tell Xorg to use the nvidia driver
  # The services.xserver.videoDrivers setting is also
  # valid for wayland installations despite it's name
  services.xserver.videoDrivers = ["nvidia"];
}
