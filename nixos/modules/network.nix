{ config, lib, ... }: {

  services.tailscale.enable = true;

  networking = {
    enableIPv6 = lib.mkDefault false;
    useDHCP = lib.mkDefault false;
    networkmanager.enable = lib.mkDefault false;
    nameservers = [
      "100.69.22.72" # adguardhome dns using tailscale.
#      "9.9.9.9"
    ];
    firewall = {
      enable = true;
      allowedTCPPorts = [
        2049 # NFSv4
        53 # dns
#        80
#        443
      ];
      allowedUDPPorts = [
        config.services.tailscale.port
        53 # dns
#        80
#        443
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
        "BELL248" = {
          priority = 0;
          auth = ''
           psk=9f41abf6a150bbf3eb7ca1bb6fb9a5fff55e788ce8ad3db634d4336746257e45
           proto=RSN
          	key_mgmt=WPA-PSK
          	pairwise=CCMP
          	auth_alg=OPEN
          '';
        };
          # CHSLD Ste-Rose
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
          # Mobile Hotspot
        "bin-hotspot" = {
          priority = 3;
          auth = ''
            psk=82dd0b712d8928c6cc5f019c16cd0feab6271cf4e3505781914a5bb6cb41b63e
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
