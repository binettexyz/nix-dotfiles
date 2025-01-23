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
  
    ## FileSystem ##
    fileSystems."/nix/persist/media" = {
      device = "/dev/disk/by-label/exthdd";
      fsType = "ntfs-3g";
      options = [ "rw" "uid=1000" "gid=1000" "x-systemd.automount" "noauto" ];
      
    };
  
    environment.persistence."/nix/persist/home/binette/.local/share" = {
      hideMounts = true;
      directories = [
        { directory = "/opt"; user = "binette"; group = "binette"; mode = "u=rwx,g=rx,o="; }
      ];
    };
  };

}
