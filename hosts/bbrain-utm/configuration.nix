{
  self,
  inputs,
  outputs,
  config,
  pkgs,
  lib,
  options,
  ...
}:
{
  boot.loader.systemd-boot.enable = true;
  # boot.loader.systemd-boot.configurationLimit = 4;
  # boot.loader.efi.canTouchEfiVariables = true;
  # boot.kernelParams = [ ];
  # boot.kernelModules = [ "coretemp" ];
  # boot.initrd.kernelModules = [
  #   "dm-raid"
  #   "raid1"
  # ];
  # boot.binfmt.emulatedSystems = [ "aarch64-linux" ];
  # boot.binfmt.registrations."aarch64-linux".fixBinary = true;
  # boot.binfmt.registrations."aarch64-linux".matchCredentials = true;
  # https://github.com/NixOS/nixpkgs/pull/334859

  # boot.binfmt.registrations.aarch64-linux = {
  #   interpreter = "${pkgs.pkgsStatic.qemu-user}/bin/qemu-aarch64";
  #   wrapInterpreterInShell = false;
  #   fixBinary = true;
  #   openBinary = true; # debatable, see https://github.com/NixOS/nixpkgs/pull/314998#issuecomment-2237347334
  #   matchCredentials = true;
  #   preserveArgvZero = true;
  # };

  environment.systemPackages = [
    pkgs.qemu-user
    # pkgs.jetbrains.jdk
    pkgs.usbutils
    pkgs.qt6.qtwayland
    pkgs.qt5.qtwayland
    pkgs.libva
    pkgs.cifs-utils
    pkgs.qmk
    pkgs.python311
    (pkgs.python3.withPackages (
      ps: with ps; [
        flake8
        ruamel-yaml
        requests
        toml
        types-toml
        sh
        debugpy
        pywinrm
      ]
    ))
  ];

  # programs.thunar.enable = true;
  # services.gvfs.enable = true;
  # services.tumbler.enable = true;
  # programs.xfconf.enable = true;
  # programs.thunar.plugins = with pkgs.xfce; [
  #   thunar-archive-plugin
  #   thunar-volman
  # ];
  programs.nix-ld.enable = true;
  programs.nix-ld.libraries =
    options.programs.nix-ld.libraries.default
    ++ (with pkgs; [
      libxcrypt
      glib
      nss
      nspr
      dbus
      at-spi2-atk
      cups
      libdrm
      libuuid
      gtk3
      libnotify
      pango
      cairo
      xorg.libX11
      xorg.libXcomposite
      xorg.libXdamage
      xorg.libXfixes
      xorg.libxcb
      libgbm
      expat
      alsa-lib
      xdg-utils
      # xorg.libXext
      # xorg.libXi
      # xorg.libXrandr
    ]);

  fonts.packages = [
    pkgs.corefonts
  ]
  ++ builtins.filter lib.attrsets.isDerivation (builtins.attrValues pkgs.nerd-fonts);

  # Need to create /etc/nixos/smb-secrets with the following content:
  # username=<USERNAME>
  # password=<PASSWORD>
  # fileSystems."/mnt/Freebox/Backup" = {
  #   device = "//192.168.1.254/Backup";
  #   fsType = "cifs";
  #   options =
  #     let
  #       user_opts = "uid=1000";
  #       automount_opts = "x-systemd.automount,noauto,x-systemd.idle-timeout=60,x-systemd.device-timeout=5s,x-systemd.mount-timeout=5s";
  #     in
  #     [ "${automount_opts},credentials=/etc/nixos/smb-secrets,${user_opts}" ];
  # };
  #
  # fileSystems."/mnt/Freebox/HDD_2TiB" = {
  #   device = "//192.168.1.254/HDD 2TiB";
  #   fsType = "cifs";
  #   options =
  #     let
  #       user_opts = "uid=1000";
  #       automount_opts = "x-systemd.automount,noauto,x-systemd.idle-timeout=60,x-systemd.device-timeout=5s,x-systemd.mount-timeout=5s";
  #     in
  #     [ "${automount_opts},credentials=/etc/nixos/smb-secrets,${user_opts}" ];
  # };

  networking.hostName = "bbrain-utm"; # Define your hostname.
  networking.networkmanager.enable = true;

  # Local k8s cluster with direct access
  networking.search = [ "dns.podman" ];
  networking.nameservers = [
    # "127.0.0.1"
    # "::1"
    "8.8.8.8"
  ];
  networking.hosts = {
    "172.16.0.200" = [ "kind-ingress.dns.podman" ];
  };
  services.coredns = {
    enable = true;
    package = pkgs.stable.coredns;
    config = ''
      . {
        bind 127.0.0.1 ::1
        forward dns.podman 172.16.0.1
        forward . 1.1.1.1 1.0.0.1 192.168.1.1 fd0f:ee:b0::1
      }
    '';
  };
  networking.interfaces.enp39s0.wakeOnLan.enable = true;

  networking = {
    wireguard.enable = true;
    wireguard.interfaces = {
      # wg0 = {
      #   ips = [ "192.168.27.69/32" ];
      #   listenPort = 51820;
      #   privateKeyFile = "/home/jscherrer/.config/wireguard/privatekey";
      #   peers = [
      #     {
      #       publicKey = "kPDTM5DF/IzZ3h8Akd4mE20utzaKsbxmk9UEtI+SPi0=";
      #       allowedIPs = [
      #         "192.168.27.64/27"
      #         # "192.168.1.0/24"
      #         "192.168.14.0/24"
      #       ];
      #       endpoint = "82.66.46.243:30195";
      #       persistentKeepalive = 25;
      #     }
      #   ];
      # };
    };
  };

  boot.kernel.sysctl = {
    "net.ipv4.ip_unprivileged_port_start" = 80;
    "fs.inotify.max_user_instances" = 1024;
    "fs.file-max" = 9223372036854775807;
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

  services.xserver.xkb = {
    layout = "us";
    variant = "intl";
  };

  services.cloudflare-warp = {
    enable = true;
  };

  console.keyMap = "us-acentos";

  users.users.jscherrer = {
    isNormalUser = true;
    description = "Jonathan Scherrer";
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
    packages = with pkgs; [ ];
  };

  system.stateVersion = "23.05"; # Did you read the comment?

  # home-manager = {
  #   useGlobalPkgs = true;
  #   useUserPackages = true;
  #   users.jscherrer = import "${self}/home/jscherrer/bbrain-utm.nix";
  #   users.root = import "${self}/home/root";
  #   extraSpecialArgs = {
  #     inherit inputs outputs;
  #   };
  # };

  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    WLR_NO_HARDWARE_CURSORS = "1";
  };

  services.flatpak.enable = true;
  services.logind.settings.Login = {
    HandlePowerKey = "suspend";
    IdleAction = "suspend";
    IdleActionSec = 60;
  };

  security.rtkit.enable = true;

  xdg.portal = {
    enable = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-gtk
    ];
    config.common.default = "*";
  };

  networking.firewall = {
    enable = true;
    allowedTCPPorts = [
      6666
    ];
    allowedTCPPortRanges = [
      {
        from = 6666;
        to = 6670;
      }
    ];
    allowedUDPPorts = [
      8211
      51820
    ];
  };
}
