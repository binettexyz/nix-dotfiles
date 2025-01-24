{ inputs, pkgs, config, lib, ... }:
with lib;

{

  imports = [ ./containers ];

  config = lib.mkIf (config.device.type == "server") {

    services.nfs.server = {
      enable = true;
      exports = ''
        /media 100.91.89.2(rw,insecure,no_subtree_check)
        /media 100.67.150.87(rw,insecure,no_subtree_check)
      '';
    };

#    services.nginx.enable = true;

#TODO    services.dnsmasq.enable = true;

        # Docker
    virtualisation.podman = {
      enable = true;
      dockerCompat = true;
      enableNvidia = lib.mkDefault false;
      autoPrune.enable = true;
    };
  
    virtualisation.oci-containers.backend = "podman";
  };

}
