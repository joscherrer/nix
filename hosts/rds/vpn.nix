{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}:
{
  sops.secrets."rds-vpn/gateway" = {
    sopsFile = ../../secrets/rds-vpn.yaml;
    key = "gateway";
  };
  sops.secrets."rds-vpn/leftid" = {
    sopsFile = ../../secrets/rds-vpn.yaml;
    key = "leftid";
  };
  sops.secrets."rds-vpn/xauthUsername" = {
    sopsFile = ../../secrets/rds-vpn.yaml;
    key = "xauthUsername";
  };
  sops.secrets."rds-vpn/wgAddress" = {
    sopsFile = ../../secrets/rds-vpn.yaml;
    key = "wgAddress";
  };
  sops.secrets."rds-vpn/wgPeerPublicKey" = {
    sopsFile = ../../secrets/rds-vpn.yaml;
    key = "wgPeerPublicKey";
  };
  sops.secrets."rds-vpn/wgAllowedIps" = {
    sopsFile = ../../secrets/rds-vpn.yaml;
    key = "wgAllowedIps";
  };
  sops.secrets."rds-vpn/wgEndpoint" = {
    sopsFile = ../../secrets/rds-vpn.yaml;
    key = "wgEndpoint";
  };

  sops.templates."claranet-ipsec.conf" = {
    content = ''
      conn claranet
        authby=secret
        left=%defaultroute
        leftid=${config.sops.placeholder."rds-vpn/leftid"}
        leftsendcert=always
        leftxauthclient=yes
        leftmodecfgclient=yes
        leftxauthusername=${config.sops.placeholder."rds-vpn/xauthUsername"}
        modecfgpull=yes
        right=${config.sops.placeholder."rds-vpn/gateway"}
        rightxauthserver=yes
        rightmodecfgserver=yes
        nm-configured=no
        cisco-split=yes
        cisco-unity=yes
        aggressive=yes
        rekey=yes
        dpdtimeout=60s
        dpddelay=20s
        auto=add
        ike=aes256-sha256-dh14
        ikelifetime=86400s
        salifetime=43200s
        esp=aes256-sha256-dh14
        pfs=yes
        keyexchange=ikev1
        fragmentation=yes
        compress=no
        nat-ikev1-method=drafts
        esn=either
        nopmtudisc=yes
        remote-peer-type=cisco
        nat-keepalive=no
    '';
    restartUnits = [ "ipsec.service" ];
  };

  # Rendered at activation (never touches the Nix store), picked up by
  # libreswan alongside its own generated /etc/ipsec.d/01-nixos.conf.
  environment.etc."ipsec.d/claranet.conf".source = config.sops.templates."claranet-ipsec.conf".path;

  services.libreswan = {
    enable = true;
    configSetup = ''
      plutodebug=none
      virtual-private=%v4:10.0.0.0/8,%v4:192.168.0.0/16,%v4:172.16.0.0/12,%v4:25.0.0.0/8,%v4:100.64.0.0/10,%v6:fd00::/8,%v6:fe80::/10
      protostack=netkey
      uniqueids=no
      secretsfile=/etc/ipsec.d/claranet.secrets
      ikev1-policy=accept
    '';
  };

  # The peer's public key, endpoint and allowed-IPs reveal a home IP and
  # internal network layout, so they're kept out of the Nix store entirely:
  # `peers`/`ips` are left empty here and applied imperatively in postSetup
  # from a sops-rendered runtime file instead of as literal module options.
  sops.templates."wg0-peer.env" = {
    content = ''
      WG_ADDRESS=${config.sops.placeholder."rds-vpn/wgAddress"}
      WG_PEER_PUBLIC_KEY=${config.sops.placeholder."rds-vpn/wgPeerPublicKey"}
      WG_ALLOWED_IPS=${config.sops.placeholder."rds-vpn/wgAllowedIps"}
      WG_ENDPOINT=${config.sops.placeholder."rds-vpn/wgEndpoint"}
    '';
    restartUnits = [ "wireguard-wg0.service" ];
  };

  networking = {
    wireguard.enable = false;
    wireguard.interfaces = {
      wg0 = {
        mtu = 1360;
        ips = [ ];
        listenPort = 51820;
        privateKeyFile = "/home/jscherrer/.config/wireguard/privatekey";
        peers = [ ];
        postSetup = ''
          . ${config.sops.templates."wg0-peer.env".path}
          ip address add "$WG_ADDRESS" dev wg0
          wg set wg0 peer "$WG_PEER_PUBLIC_KEY" allowed-ips "$WG_ALLOWED_IPS" endpoint "$WG_ENDPOINT"
        '';
      };
    };
  };

  # programs.openvpn3 = {
  #   enable = true;
  # };

  # VPN RDS (vpn.rdsdiag.com) requires SSO/SAML login over IPsec, which no
  # Linux client we tried can actually deliver standalone:
  # - libreswan/strongswan can't do FortiGate's non-standard SAML-over-IKEv2.
  # - openfortivpn only speaks SSL VPN, and this gateway doesn't offer one.
  # - FortiClient's full/EMS-capable Linux build (7.4.x, 8.0) can configure
  #   and connect the IPsec+SAML tunnel, but ships `epctrl` (endpoint
  #   control), which tears the tunnel down ~10s after connecting unless
  #   registered to EMS - matches the Linux 7.4.3 release notes verbatim:
  #   "FortiClient (Linux) 7.4.3 features are only enabled when connected to
  #   EMS."
  # - FortiClient's free VPN-only build has no epctrl/certd, but its GUI
  #   hardcodes hiding the IPsec option when adding a new connection, and its
  #   confighandler doesn't even see an IPsec profile already in config.db.
  # PSK is in secrets/rds-fortivpn.secrets (sops) if this gets revisited.
  # Blocked on IT/network admin re: EMS registration or compliance policy
  # for this VPN profile.
}
