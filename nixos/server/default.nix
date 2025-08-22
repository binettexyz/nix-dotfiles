{
  config,
  lib,
  deviceType,
  ...
}: {
  imports = [./containers];

  config = lib.mkIf (deviceType == "server") {
    # ---Network File System---
    services.nfs.server = {
      enable = true;
      exports = ''
        /data 100.96.225.88(rw,insecure,no_subtree_check)
        /data 100.95.71.37(rw,insecure,no_subtree_check)
        /data 100.66.28.9(rw,insecure,no_subtree_check)
      '';
    };

    # ---Docker Container---
    virtualisation = {
      podman = {
        enable = true;
        dockerCompat = true;
        enableNvidia = lib.mkDefault false;
        autoPrune.enable = true;
      };
      oci-containers.backend = "podman";
    };

    # ---Networking---
    services.nginx = {
      enable = true;
      virtualHosts = {
        "default" = {
          # Set this vhost as the default.
          default = true;
          listen = [
            { port = 443; ssl = true; addr = "[::]"; }
            { port = 80; addr = "[::]"; }
            { port = 443; ssl = true; addr = "0.0.0.0"; }
            { port = 80; addr = "0.0.0.0"; }
          ];
          # Avoid any subdomaine being redirect to another vhost.
          rejectSSL = true;
        };
        "jbinette.xyz" = {
          forceSSL = true;
          enableACME = true;
          locations."/".extraConfig = ''
            default_type text/plain;
            return 200 "Root domain reserved.";
          '';
        };
      };
    };

    # Bridge for Ethernet
#    networking = {
#      firewall.allowedTCPPorts = [80 443];
#      useDHCP = false;
#      nat = {
#        enable = true;
#        internalInterfaces = ["br0"];
#        externalInterface = "eth0";
#      };
#      bridges.br0.interfaces = ["eth0"]; # Adjust interface accordingly
#      # Set bridge-ip static
#      # If bridge stop working and theres no internet inside containers,
#      # change address to "192.168.2.100", rebuild, reboot and put it back to 192.168.100.1.
#      interfaces."br0".ipv4.addresses = [
#        {
#          address = "192.168.100.1";
#          prefixLength = 24;
#        }
#      ];
#    };

    # Bridge for WIFI
    networking = {
      firewall.allowedTCPPorts = [80 443];
      useDHCP = false;
    
      # NAT: route container traffic out through WiFi
      nat = {
        enable = true;
        internalInterfaces = [ "br0" ];
        externalInterface = "wlan0"; # use WiFi instead of eth0
      };
    
      # Create a bridge, but don’t enslave wlan0 (WiFi can't be bridged)
      bridges.br0.interfaces = [ ]; # empty list
    
      # Give the bridge a static IP
      interfaces."br0".ipv4.addresses = [
        {
          address = "192.168.100.1";
          prefixLength = 24;
        }
      ];
    };

  };
}
