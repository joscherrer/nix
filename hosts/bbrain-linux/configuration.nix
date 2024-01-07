{ self, inputs, outputs, config, pkgs, lib, ... }:
{
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelParams = ["nvidia.NVreg_PreserveVideoMemoryAllocations=1"];
  boot.kernelModules = [ "coretemp" ];
  boot.initrd.kernelModules = [
    "dm-raid"
    "raid1"
  ];

  environment.systemPackages = [
    pkgs.stable.jetbrains.jdk
    pkgs.stable.jetbrains.idea-community
    # pkgs.unstable.jetbrains.gateway
    pkgs.usbutils
    pkgs.semeru-bin-8
    pkgs.qt6.qtwayland
    pkgs.qt5.qtwayland
    pkgs.libva
    pkgs.unstable.xwaylandvideobridge
    pkgs.wineWowPackages.waylandFull
    pkgs.cifs-utils
  ];

  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;
  services.blueman.enable = true;

  programs.thunar.enable = true;
  services.gvfs.enable = true;
  services.tumbler.enable = true;
  programs.xfconf.enable = true;
  programs.thunar.plugins = with pkgs.xfce; [
    thunar-archive-plugin
    thunar-volman
  ];

  fonts.packages = [
    pkgs.nerdfonts
  ];
  
  # Need to create /etc/nixos/smb-secrets with the following content:
  # username=<USERNAME>
  # password=<PASSWORD>
  fileSystems."/mnt/Freebox/Backup" = {
    device = "//192.168.1.254/Backup";
    fsType = "cifs";
    options = let
      user_opts = "uid=1000";
      automount_opts = "x-systemd.automount,noauto,x-systemd.idle-timeout=60,x-systemd.device-timeout=5s,x-systemd.mount-timeout=5s";
    in ["${automount_opts},credentials=/etc/nixos/smb-secrets,${user_opts}"];
  };

  fileSystems."/mnt/Freebox/HDD_2TiB" = {
    device = "//192.168.1.254/HDD 2TiB";
    fsType = "cifs";
    options = let
      user_opts = "uid=1000";
      automount_opts = "x-systemd.automount,noauto,x-systemd.idle-timeout=60,x-systemd.device-timeout=5s,x-systemd.mount-timeout=5s";
    in ["${automount_opts},credentials=/etc/nixos/smb-secrets,${user_opts}"];
  };

  nixpkgs.config.allowUnfree = true;

  networking.hostName = "bbrain-linux"; # Define your hostname.
  networking.networkmanager.enable = true;

  # Local k8s cluster with direct access
  networking.search = [ "dns.podman" ];
  networking.nameservers = ["127.0.0.1" "::1"];
  networking.hosts = {
    "172.16.0.200" = ["kind-ingress.dns.podman"];
  };
  services.coredns = { 
    enable = true;
    config = ''
    . {
      bind 127.0.0.1 ::1
      forward dns.podman 172.16.0.1
      forward . 1.1.1.1 1.0.0.1 192.168.1.254 fd0f:ee:b0::1
    }
    '';
  };
  networking.interfaces.enp39s0.wakeOnLan.enable = true;

  boot.kernel.sysctl = {
    "net.ipv4.ip_unprivileged_port_start" = 80;
    "fs.inotify.max_user_instances" = 1024;
  };

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
    users.root = import "${self}/home/root";
    extraSpecialArgs = { inherit inputs outputs; };
  };

  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
  };

  hardware.nvidia = {
    modesetting.enable = true;
    open = false;
    powerManagement.enable = true;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.production;
  };

  environment.sessionVariables = {
    # LIBVA_DRIVER_NAME = "nvidia";
    # GBM_BACKEND = "nvidia-drm";
    NIXOS_OZONE_WL = "1";
    WLR_NO_HARDWARE_CURSORS = "1";
    # __GLX_VENDOR_LIBRARY_NAME = "nvidia";
  };

  # Tell Xorg to use the nvidia driver
  # The services.xserver.videoDrivers setting is also
  # valid for wayland installations despite it's name
  services.xserver.videoDrivers = [ "nvidia" ];
  services.flatpak.enable = true;
  services.logind.extraConfig = ''
    HandlePowerKey=suspend
    IdleAction=suspend
    IdleActionSec=60
  '';

  security.rtkit.enable = true;

  xdg.portal = {
    enable = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-gtk
    ];
    config.common.default = "*";
  };

  services.udev.extraRules = ''
    ACTION=="add", ATTR{idProduct}=="0002", ATTR{idVendor}=="a103", RUN="${pkgs.bash}/bin/bash -c 'echo enabled > /sys%E{DEVPATH}/power/wakeup'"
  '';
}
