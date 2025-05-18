{
  config,
  lib,
  deviceType,
  ...
}:
{

  imports = [ ./containers ];

  config = lib.mkIf (deviceType == "server") {

    # ---Network File System---
    services.nfs.server = {
      enable = true;
      exports = ''
        /media 100.96.225.88(rw,insecure,no_subtree_check)
        /media 100.102.251.119(rw,insecure,no_subtree_check)
        /media 100.95.71.37(rw,insecure,no_subtree_check)
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
      virtualHosts."jbinette.xyz" = {
        forceSSL = true;
        enableACME = true;
        locations."/".extraConfig = ''
          default_type text/plain;
          return 200 "Root domain reserved. Use cloud.jbinette.xyz or git.jbinette.xyz";
        '';
      };
    };

    networking = {
      firewall.allowedTCPPorts = [ 80 443 ];
      useDHCP = false;
      nat = {
        enable = true;
        internalInterfaces = ["br0"];
        externalInterface = "eth0";
      };
      bridges.br0.interfaces = [ "eth0" ]; # Adjust interface accordingly
      # Set bridge-ip static
      interfaces."br0".ipv4.addresses = [{
        address = "192.168.100.1";
        prefixLength = 24;
      }];
    };
  };

}
