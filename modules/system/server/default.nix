{ inputs, pkgs, config, lib, ... }:
with lib;

let
  cfg = config.modules.profiles.server;
in
{
  imports = [ ./containers ];

  options.modules.profiles.server = {
    enable = mkOption {
      description = "Enable server options";
      type = types.bool;
      default = false;
    };
  };

  config = mkIf (cfg.enable) {

    modules = {
      containers = {
        bazarr.enable = true;
        deluge.enable = false;
        jackett.enable = true;
        plex.enable = true;
        jellyfin.enable = true;
        radarr.enable = true;
        sonarr.enable = true;
        transmission.enable = true;
      };
      services = {
        adGuardHome.enable = true;
        miniflux.enable = false;
      };
    };
  
    services.nfs.server = {
      enable = true;
      exports = ''
        /media 100.91.89.2(rw,insecure,no_subtree_check)
        /media 100.95.71.37(rw,insecure,no_subtree_check)
      '';
    };
  
    networking.nat = {
      enable = true;
      externalInterface = "wlan0";
    };
  
    ## FileSystem ##
    fileSystems."/nix/persist/media" = {
      device = "/dev/disk/by-label/exthdd";
      fsType = "ntfs";
      options = [ "rw" "uid=1000" "gid=100" "x-systemd.automount" "noauto" ];
      
    };
  
    environment.persistence."/nix/persist" = {
      hideMounts = true;
      directories = [
        "/media"
      ];
    };
  };

}
