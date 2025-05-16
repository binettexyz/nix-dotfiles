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
#      exports = ''
#        /media 100.91.89.2(rw,insecure,no_subtree_check)
#        /media 100.67.150.87(rw,insecure,no_subtree_check)
#      '';
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

    # ---Network Bridge---
    networking = {
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
