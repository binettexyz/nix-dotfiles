{ config, pkgs, lib, ... }:
with lib;
let
  cfg = config.modules.containers.servarr;
#  privateKeyFile = [
#    config.sops.secrets.apiKey.sonarr.path;
#    config.sops.secrets.apiKey.radarr.path;
#  ];
  hostAddress = "10.0.0.12";
  localAddress = "10.0.1.12";
  sonarrDataDir = "/nix/persist/srv/container-service-data/sonarr";
  radarrDataDir = "/nix/persist/srv/container-service-data/radarr";
  jackettDataDir = "/nix/persist/srv/container-service-data/jackett";
  jellyfinDataDir = "/var/lib/jellyfin";
  mediaDir = "/media/videos";
  downloadDir = "/media/downloads/torrents";
  ports = {
    sonarr = 8989;
    radarr = 7878;
    jackett = 9117;
    transmission = 9091;
    jellyfin = 8096;
  };
  mkLocalProxy = port: {
    locations."/".proxyPass = "http://localhost:" + toString(port);
  };
in
{
  options.modules.containers.servarr = {
    enable = mkEnableOption "servarr";
  };

  config = mkIf (cfg.enable) {
    services.nginx.virtualHosts = {
      "sonarr.box" = mkLocalProxy ports.sonarr;
      "radarr.box" = mkLocalProxy ports.radarr;
      "jackett.box" = mkLocalProxy ports.jackett;
      "trans.box" = mkLocalProxy ports.transmission;
      "jellyfin.box" = mkLocalProxy ports.jellyfin;
    };

    systemd.tmpfiles.rules = [
      "d ${sonarrDataDir} - - - -"
      "d ${radarrDataDir} - - - -"
      "d ${jackettDataDir} - - - -"
      "d ${jellyfinDataDir} - - - -"
    ];
  
    /*  ---Main container--- */
    containers.servarr = {
      ephemeral = true;
      autoStart = true;
  
      privateNetwork = false;
      inherit localAddress hostAddress;
  
      bindMounts = {
  #      "${privateKeyFile}" = { hostPath = privateKeyFile; isReadOnly = true; };
        "/media/videos/movies" = { hostPath = mediaDir + "/movies"; isReadOnly = false; };
        "/media/videos/tv" = { hostPath = mediaDir + "/tv"; isReadOnly = false; };
        "/media/videos/animes" = { hostPath = mediaDir + "/animes"; isReadOnly = false; };
        "/media/downloads/torrents" = { hostPath = downloadDir; isReadOnly = false; };
        "/var/lib/sonarr/.config" = { hostPath = sonarrDataDir; isReadOnly = false; };
        "/var/lib/radarr/.config" = { hostPath = radarrDataDir; isReadOnly = false; };
        "/var/lib/jackett/.config" = { hostPath = jackettDataDir; isReadOnly = false; };
        "/var/lib/jellyfin" = { hostPath = jellyfinDataDir; isReadOnly = false; };
      };

      config = { pkgs, ... }: {
#        networking.firewall.enable = false;
        systemd.tmpfiles.rules = [
#          "d /media/videos/movies 777 radarr media -"
          "d ${builtins.toString mediaDir + "/movies"} 777 radarr media -"
          "d ${builtins.toString mediaDir + "/tv"} 777 sonarr media -"
          "d ${builtins.toString mediaDir + "/animes"} 777 sonarr media -"
          "d ${builtins.toString downloadDir} 777 transmission media -"
        ];

#        networking.wg-quick.interfaces = {
#          wg0 = {
#            inherit privateKeyFile;
#            address = [ "10.64.201.123/32" "fc00:bbbb:bbbb:bb01::1:c97a/128" ];
#            dns = [ "193.138.218.74" ];
#            peers = [
#              {
#                publicKey = "qzi6yOzbLmoJXYYLzijkA5GO9lFhcEwglxI5qi4NpCI=";
#                allowedIPs = [ "0.0.0.0/0" "::0/0" ];
#                endpoint = "198.54.129.66:51820";
#              }
#            ];
#          };
#        };

        networking.firewall = {
          allowedTCPPorts = [
            ports.radarr
            ports.sonarr
            ports.jackett
            ports.transmission
            ports.jellyfin
          ];
#          allowedUDPPorts = [ 51820 ]; # wireguard
        };

        users.groups.media = {
          members = [ "radarr" "radarr" "sonarr" "transmission" "jellyfin" ];
          gid = 3000;
        };

        #TODO: readarr service
        services.radarr = {
          enable = true;
          group = "media";
        };
        services.sonarr = {
          enable = true;
          group = "media";
        };
        services.jellyfin = {
          enable = true;
          group = "media";
        };
        services.jackett.enable = true;
        services.transmission = {
          enable = true;
          group = "media";
          settings = {
            blocklist-enabled = true;
            blocklist-url = "http://list.iblocklist.com/?list=ydxerpxkpcfqjaybcssw&fileformat=p2p&archiveformat=gz";
            download-dir = downloadDir;
            incomplete-dir-enabled = true;
            incomplete-dir = downloadDir + "/.incomplete";
            encryption = 1;
            message-level = 1;
            peer-port = 50778;
            peer-port-random-high = 65535;
            peer-port-random-low = 49152;
            peer-port-random-on-start = true;
            rpc-enable = true;
            rpc-bind-address = "0.0.0.0";
            rpc-port = ports.transmission;
            rpc-whitelist-enabled = false;
            rpc-authentication-required = true;
            rpc-username = "binette";
            rpc-password = "cd";
            umask = 18;
            utp-enabled = true;
          };
        };

        system.stateVersion = "22.11";
      };
    };
  };
}
