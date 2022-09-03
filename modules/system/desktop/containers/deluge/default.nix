{ pkgs, config, lib, ... }:
with lib;

let
  cfg = config.modules.containers.deluge;
in
{
  options.modules.containers.deluge = {
    enable = mkOption {
      description = "Enable deluge services";
      type = types.bool;
      default = false;
    };
  };

  config = mkIf (cfg.enable) {
    networking.nat.internalInterfaces = [ "ve-deluge" ];
    networking.firewall.allowedTCPPorts = [ 8112 ];

    containers.deluge = {
      autoStart = true;
        # starts fresh every time it is updated or reloaded
  #    ephemeral = true;
  
        # networking & port forwarding
      privateNetwork = false;
  #    hostBridge = "br0";
  #    hostAddress = "192.168.100.13";
  #    localAddress = "192.168.100.23";
  
        # mounts
      bindMounts = {
        "/var/lib/deluge" = {
          hostPath = "/nix/persist/var/lib/deluge";
          isReadOnly = false;
        };
        "/media" = {
          hostPath = "/media";
          isReadOnly = false;
        };
      };
  
      forwardPorts = [
  			{
  				containerPort = 8112;
  				hostPort = 8112;
  				protocol = "tcp";
  			}
  		];
  
      config = { config, pkgs, ... }: {
  
        system.stateVersion = "22.05";
        networking.hostName = "deluge";
  
        services.deluge = {
          enable = true;
          user = "deluge";
          group = "deluge";
  
          web = {
            enable = true;
            port = 8112;
            openFirewall = true;
          };
  
          declarative = true;
          dataDir = "/var/lib/deluge";
          openFirewall = true;
          authFile = "/var/lib/deluge/auth";
  
          config = {
            "add_paused" = false;
            "allow_remote" = true;
            "auto_managed" = true;
            "copy_torrent_file" = true;
            "del_copy_torrent_file" = false;
            "dht" = true;
            "dont_count_slow_torrents" = true;
            "download_location" = "/media/downloads/torrents/incoming";
            "enabled_plugins" = [
              "Extractor"
            ];
            "listen_interface" = "";
            "listen_ports" = [ 6242 6242 ];
            "listen_reuse_port" = true;
            "max_active_downloading" = 10;
            "max_active_limit" = 100;
            "max_active_seeding" = 100;
            "max_connections_global" = 200;
            "max_connections_per_second" = 20;
            "max_connections_per_torrent" = -1;
            "max_download_speed" = -1.0;
            "max_download_speed_per_torrent" = -1;
            "max_half_open_connections" = 50;
            "max_upload_slots_global" = 4;
            "max_upload_slots_per_torrent" = -1;
            "max_upload_speed" = -1.0;
            "max_upload_speed_per_torrent" = -1;
            "move_completed" = true;
            "move_completed_path" = "/media/downloads/torrents/finished";
            "natpmp" = true;
            "new_release_check" = false;
            "random_outgoing_ports" = true;
            "seed_time_limit" = 86400;
            "seed_time_ratio_limit" = 10.0;
            "stop_seed_at_ratio" = true;
            "stop_seed_ratio" = 6.0;
            "torrentfiles_location" = "/mnt/downloads/torrents";
            "upnp" = true;
            "utpex" = true;
          };
        };
      };
    };
  };

}
