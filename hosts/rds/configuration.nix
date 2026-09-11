# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

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
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.systemd-boot.configurationLimit = 20;
  boot.kernelPackages = pkgs.linuxPackages_6_18;

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
      libX11
      libXcomposite
      libXdamage
      libXfixes
      libxcb
      libgbm
      expat
      alsa-lib
      xdg-utils
      # xorg.libXext
      # xorg.libXi
      # xorg.libXrandr
    ]);

  networking.hostName = "rds"; # Define your hostname.

  # Was disabled after breaking under the Lua Hyprland config migration;
  # re-enabled here to fix the actual regreet/kiosk config instead.
  services.greetd.enable = lib.mkForce true;
  services.displayManager.regreet.enable = lib.mkForce true;

  networking.networkmanager = {
    enable = true;
    plugins = with pkgs; [
      networkmanager-openvpn
    ];
  };

  time.timeZone = "Europe/Paris";

  i18n.defaultLocale = "en_US.UTF-8";

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

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    users.jscherrer = import "${self}/home/jscherrer/rds.nix";
    users.root = import "${self}/home/root";
    extraSpecialArgs = { inherit inputs outputs; };
  };

  fonts.packages =
    [ ] ++ builtins.filter lib.attrsets.isDerivation (builtins.attrValues pkgs.nerd-fonts);

  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;
  services.blueman.enable = true;

  nixpkgs.config.allowUnfree = true;

  services.gnome.gnome-keyring = {
    enable = true;
  };

  services.tlp = {
    enable = true;
  };

  environment.systemPackages = with pkgs; [
    pkgs.uv
    pkgs.networkmanager-l2tp
    # pkgs.python311
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
        boto3
        botocore
        dbus-python
        ansible-core
        ansible
        keyring
      ]
    ))
  ];

  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
  };

  # Work around the CalDigit TS4 dock's USB tree repeatedly disconnecting
  # and re-enumerating for minutes after suspend/resume (keyboard/monitors
  # on the dock dropping out), by disabling USB autosuspend on hub-class
  # devices so the dock's internal hubs don't power-cycle mid-resume.
  services.udev.extraRules = ''
    ACTION=="add", SUBSYSTEM=="usb", ATTR{bDeviceClass}=="09", TEST=="power/control", ATTR{power/control}="on"
  '';

  # Safety net for the internal panel staying black when the lid is opened
  # onto a session that already finished resuming (e.g. some other wakeup
  # source, like the dock, resumed the system while the lid was still
  # closed). logind's suspend/resume D-Bus signal (which drives
  # hypridle's after_sleep_cmd) doesn't fire in that case, so hook the
  # physical lid switch directly and force the same dpms-on dispatch.
  services.acpid = {
    enable = true;
    lidEventCommands = ''
      case "$1" in
        *open*)
          uid=$(${pkgs.coreutils}/bin/id -u jscherrer)
          runtime_dir="/run/user/$uid"
          sig=$(${pkgs.coreutils}/bin/ls "$runtime_dir/hypr" 2>/dev/null | ${pkgs.coreutils}/bin/head -n1)
          if [ -n "$sig" ]; then
            ${pkgs.coreutils}/bin/sleep 3
            ${pkgs.util-linux}/bin/runuser -u jscherrer -- \
              ${pkgs.coreutils}/bin/env XDG_RUNTIME_DIR="$runtime_dir" HYPRLAND_INSTANCE_SIGNATURE="$sig" \
              ${config.programs.hyprland.package}/bin/hyprctl dispatch 'hl.dsp.dpms("on")'
              ${config.programs.hyprland.package}/bin/hyprctl dispatch 'hl.dsp.force_renderer_reload()'
          fi
          ;;
      esac
    '';
  };

  services.logind = {
    settings = {
      Login = {
        # HandleLidSwitch = "suspend";
        # HandleLidSwitchExternalPower = lib.mkForce "ignore";
        HandlePowerKey = "suspend";
        HandlePowerKeyLongPress = "poweroff";
        HandleSuspendKey = "suspend";
      };
    };
  };

  system.stateVersion = "25.05"; # Did you read the comment?

  programs.openvpn3.enable = true;

  services.resolved.enable = true;

  services.openvpn.servers = {
    ACEA = {
      autoStart = false;
      config = "config /home/jscherrer/.config/openvpn/CAL-143.ovpn";
    };

    QA = {
      autoStart = false;
      config = "config /home/jscherrer/.config/openvpn/CAL-170.ovpn";
    };

    ProductionMS121 = {
      autoStart = false;
      config = "config /home/jscherrer/.config/openvpn/CAL-166.ovpn";
    };

    # homeVPN = {
    #   config = "config /root/nixos/openvpn/homeVPN.conf ";
    # };
    # serverVPN = {
    #   config = "config /root/nixos/openvpn/serverVPN.conf ";
    # };
  };

  security.pki.certificates = [
    "-----BEGIN CERTIFICATE-----
MIIEEjCCAvqgAwIBAgIIPPphjjI5c0YwDQYJKoZIhvcNAQELBQAwgakxCzAJBgNV
BAYTAlVTMRMwEQYDVQQIDApDYWxpZm9ybmlhMRIwEAYDVQQHDAlTdW5ueXZhbGUx
ETAPBgNVBAoMCEZvcnRpbmV0MR4wHAYDVQQLDBVDZXJ0aWZpY2F0ZSBBdXRob3Jp
dHkxGTAXBgNVBAMMEEZHVDUwR1RLMjYwMzAxMTcxIzAhBgkqhkiG9w0BCQEWFHN1
cHBvcnRAZm9ydGluZXQuY29tMB4XDTI2MDcxMzA4MzYzNVoXDTM2MDcxMzA4MzYz
NVowgakxCzAJBgNVBAYTAlVTMRMwEQYDVQQIDApDYWxpZm9ybmlhMRIwEAYDVQQH
DAlTdW5ueXZhbGUxETAPBgNVBAoMCEZvcnRpbmV0MR4wHAYDVQQLDBVDZXJ0aWZp
Y2F0ZSBBdXRob3JpdHkxGTAXBgNVBAMMEEZHVDUwR1RLMjYwMzAxMTcxIzAhBgkq
hkiG9w0BCQEWFHN1cHBvcnRAZm9ydGluZXQuY29tMIIBIjANBgkqhkiG9w0BAQEF
AAOCAQ8AMIIBCgKCAQEAwuLVsT9hBbJLp3NDddjYEBk8tARqzn+g2GI1iMkFOL1k
XU2OYrBuoBi3R76sw/a7avTeCWyveT6wcI9hyTFhfJLXtUhkltipLMDBimtADZNG
UheKS7A18bjrgN82dEf3PaWZYKu8BWAXImTEeLDcAeqke6bxNuL32h4BbGRfkBXB
b5ciIpIZPmLIojuk5NzQPChiNCP2L7mMC+lRaegaYkev7P3O2s9T1SZC7vJKIg/D
mFYQsXAY2iuIH9hk2FUQfOszXzlt6C5pvkskeNwWUyhyjKDB+1cMzUx4v4xfczPZ
LUopzp7PSr2++DNXK0Zv1vzCi0XI2Epz7g8fdOfq6wIDAQABozwwOjAMBgNVHRME
BTADAQH/MAsGA1UdDwQEAwICBDAdBgNVHQ4EFgQUv8MGfRhD0Dy/xW+YeXmiNCSL
1MEwDQYJKoZIhvcNAQELBQADggEBAJjA5pa4f9mRa5zpoMGYQP7atk3jxK3SUX2X
dSw7PO9IQAcLuPCMOpCrlBoHwrLwEgf+J5Yl/84nPkPxmdISm5KcFsb0Qktc572M
qIcomNftMiPRFDNI47hgrfheoGHdqcqAZAn0uHDeF8Opv4U8rEYwRSRiuOXXz9Ac
1LYWhhMx7USk8EHnvJI4JUpzf11qiAiU5hX3++VEB90xIIJPtO/28upb568S8995
qlNapowndZqlZGMaLuakEzICWwMhrSXAkC3DXmM0GUD/Br/V3QN7Kohz4MSZpJuC
7LX0KQd4iyTOGIbLEheZwVdf++5XmQ/WgC/3IVaJnl4JeAcLNIY=
-----END CERTIFICATE-----"
  ];
}
