{ config, lib, ... }:
{

  services.tailscale.enable = true;

  networking = {
    networkmanager.enable = lib.mkDefault false;

    # ---DNS---
    enableIPv6 = lib.mkDefault false;
    useDHCP = lib.mkDefault false;
    nameservers = [ "100.69.22.72" ]; # adguardhome

    # ---Firewall---
    firewall = {
      enable = true;
      allowPing = false;
      allowedTCPPorts = [
        2049 # NFSv4
        53 # dns
      ];
      allowedUDPPorts = [
        config.services.tailscale.port
        53 # dns
      ];
      # tailscale
      checkReversePath = "loose";
      trustedInterfaces = [ "tailscale0" ];
    };

    # ---Wifi---
    wireless = {
      enable = lib.mkDefault true;
      userControlled.enable = true;
      networks."BELL248" = {
        priority = 0;
        auth = ''
                 psk=9f41abf6a150bbf3eb7ca1bb6fb9a5fff55e788ce8ad3db634d4336746257e45
                 proto=RSN
              	  key_mgmt=WPA-PSK
              	  pairwise=CCMP
          	      auth_alg=OPEN
        '';
      };
    };
  };

}
