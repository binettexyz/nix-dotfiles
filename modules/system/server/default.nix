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
        adGuardHome.enable = true;
        bazarr.enable = false;
        deluge.enable = false;
        grafana.enable = false;
        jackett.enable = true;
        plex.enable = true;
        jellyfin.enable = false;
        radarr.enable = true;
        sonarr.enable = true;
        transmission.enable = true;
        mcServer.enable = true;
        home-assistant.enable = false;
      };
      services = {
        miniflux.enable = false;
      };
    };
  
    services.nfs.server = {
      enable = true;
      exports = ''
        /media 100.91.89.2(rw,insecure,no_subtree_check)
        /media 100.67.150.87(rw,insecure,no_subtree_check)
      '';
    };
  
    networking = {
      nat = {
        enable = true;
        externalInterface = "wlan0";
      };
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

    environment.persistence."/nix/persist/home/binette/.local/share" = {
      hideMounts = true;
      directories = [
        { directory = "/opt"; user = "binette"; group = "binette"; mode = "u=rwx,g=rx,o="; }
      ];
    };
  };

}
