{ config, lib, ... }: {

  services.tailscale.enable = true;

  networking = {
    enableIPv6 = lib.mkDefault false;
    useDHCP = lib.mkDefault false;
    networkmanager.enable = false;
    nameservers = [
#      "100.71.254.90" # adguardhome dns using tailscale.
#      "9.9.9.9"
    ];
    firewall = {
      enable = true;
      allowedTCPPorts = [
        2049 # NFSv4
        53 # dns
      ];
      allowedUDPPorts = [
        config.services.tailscale.port
#        51820 # wireguard
        53 # dns
      ];
      allowPing = false;
        # tailscale
      checkReversePath = "loose";
      trustedInterfaces = [ "tailscale0" ];
    };

    wireless = {
      enable = lib.mkDefault true;
      userControlled.enable = true;
      networks = {
          # Home
        "EBOX-2153-5G" = {
          priority = 0;
          auth = ''
           psk=c44e2f5c7b748c884049cff130ca93a888598868703f6160f7f45c9e3da5e74e
           proto=RSN
          	key_mgmt=WPA-PSK
          	pairwise=CCMP
          	auth_alg=OPEN
          '';
        };
          # Home
        "EBOX-2153" = {
          priority = 0;
          auth = ''
           psk=0e6a94029151fb40f2fbb513dd2534b7e7ebdc91edb13419762f0f4f0590f198
           proto=RSN
          	key_mgmt=WPA-PSK
          	pairwise=CCMP
          	auth_alg=OPEN
          '';
        };
          # CHSLD (work)
        "Loisirs" = {
          priority = 2;
          auth = ''
            psk=ca62593afdd9ec7cac04d7730061da25616f3f883aca43a4245675947acd24fb
            proto=RSN
            key_mgmt=WPA-PSK
            pairwise=CCMP
            auth_alg=OPEN
          '';
        };
      };
    };
  };


}
