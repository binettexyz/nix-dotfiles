{
  config,
  lib,
  ...
}:
{
  services.tailscale.enable = true;

  networking = {
    networkmanager.enable = lib.mkDefault false;

    # ---DNS---
    enableIPv6 = lib.mkDefault false;
    useDHCP = lib.mkDefault false;
    #nameservers = [ "100.110.153.50" ]; # adguardhome

    # ---Firewall---
    firewall = {
      enable = true;
      allowPing = false;
      allowedTCPPorts = [
        2049 # NFSv4
        #53 # dns
      ];
      allowedUDPPorts = [
        config.services.tailscale.port
        #53 # dns
      ];
      # tailscale
      checkReversePath = "loose";
      trustedInterfaces = [ "tailscale0" ];
    };

    # ---Wifi---
    wireless = {
      enable = lib.mkDefault true;
      userControlled.enable = true;
      networks."BELL920" = {
        priority = 0;
        auth = ''
          psk=612dd63c94323b70287c5785e4e53ecbec25d48ee3330b1b3d42eec0a9225a6b
          proto=RSN
          key_mgmt=WPA-PSK
          pairwise=CCMP
          auth_alg=OPEN
        '';
      };
    };
  };
}
