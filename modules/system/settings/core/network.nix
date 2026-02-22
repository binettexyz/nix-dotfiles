{
  flake.nixosModules.network =
    { config, lib, ... }:
    {
      config = lib.mkMerge [
        {
          services.tailscale.enable = true;

          networking = {

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
          };
        }
        (lib.mkIf (!(lib.elem "console" config.modules.device.tags)) {
          # ---Wifi---
          networking = {
            networkmanager.enable = lib.mkDefault false;
            wireless = {
              enable = lib.mkDefault true;
              userControlled = true;
              networks."Binette WI-FI" = {
                priority = 0;
                auth = ''
                  psk=7154d89bdf8d3f5cfa91183ef90259ce3a01bd5c9a6a241c98d1a3031ea13ef2
                  proto=RSN
                  key_mgmt=WPA-PSK
                  pairwise=CCMP
                  auth_alg=OPEN
                '';
              };
            };

          };
        })
      ];
    };
}
