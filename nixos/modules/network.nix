{ config, lib, ... }: {

  /* ---Enable/Disable network components--- */
  services.tailscale.enable = true;
  networking = {
    networkmanager.enable = lib.mkDefault false;
    wireless.enable = lib.mkDefault true;
    firewall.enable = lib.mkDefault true;
  };

  /* ---Tailscale--- */
  networking = {
    interfaces.tailscale0.useDHCP = true;
    firewall.checkInterfaces = "loose";
    firewall.trustedInterfaces = [ "tailscale0" ];
  };

  /* ---DNS--- */
  networking = {
    enableIPv6 = lib.mkDefault false;
    useDHCP = lib.mkDefault false;
    nameservers = [ "100.69.22.72" ]; # AdGuardHome
  };

  /* ---Firewall--- */
  networking.firewall = {
    allowPing = false;
    allowedTCPPorts = [
      2049 # NFSv4
      53 # dns
      #80
      #443
    ];
    allowedUDPPorts = [
      config.services.tailscale.port
      53 # dns
      #80
      #443
    ];
  };

  /* ---Wifi--- */
  networking.wireless = {
    userControlled.enable = true;
    networks."BELL248" = { # Home Wifi
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

}
