{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.modules.server.containers.servarr;
  hostAddress = "192.168.100.1";
  localAddress = "192.168.100.17";
  sonarrDataDir = "/nix/persist/srv/container-service-data/sonarr";
  radarrDataDir = "/nix/persist/srv/container-service-data/radarr";
  prowlarrDataDir = "/nix/persist/srv/container-service-data/prowlarr";
  jackettDataDir = "/nix/persist/srv/container-service-data/jackett";
  jellyfinDataDir = "/nix/persist/srv/container-service-data/jellyfin";
  mediaDir = "/data/library/media/";
  downloadDir = "/data/library/media/.downloads";
  ports = {
    sonarr = 8989;
    radarr = 7878;
    prowlarr = 9696;
    jackett = 9117;
    transmission = 9091;
    jellyfin = 8096;
    flaresolverr = 8191;
  };
  mkProxy = port: {
    useACMEHost = "jbinette.xyz";
    forceSSL = true;
    locations."/".proxyPass = "http://${localAddress}:" + toString (port);
  };
in
{
  options.modules.server.containers.servarr.enable = lib.mkOption {
    description = "Enable torrents related services";
    default = false;
  };

  config = lib.mkIf cfg.enable {
    services.nginx.virtualHosts = {
      "sonarr.jbinette.xyz" = mkProxy ports.sonarr;
      "radarr.jbinette.xyz" = mkProxy ports.radarr;
      "jackett.jbinette.xyz" = mkProxy ports.jackett;
      "prowlarr.jbinette.xyz" = mkProxy ports.prowlarr;
      "trans.jbinette.xyz" = mkProxy ports.transmission;
      "jellyfin.jbinette.xyz" = mkProxy ports.jellyfin;
    };

    systemd.tmpfiles.rules = [
      "d ${sonarrDataDir} - - - -"
      "d ${radarrDataDir} - - - -"
      "d ${prowlarrDataDir} - - - -"
      "d ${jackettDataDir} - - - -"
      "d ${jellyfinDataDir} - - - -"
    ];

    # ---Main container---
    containers.servarr = {
      autoStart = true;
      privateNetwork = true;
      hostBridge = "br0";
      inherit localAddress hostAddress;

      bindMounts = {
        "${mediaDir}/movies" = {
          hostPath = mediaDir + "/movies";
          isReadOnly = false;
        };
        "${mediaDir}/tv" = {
          hostPath = mediaDir + "/tv";
          isReadOnly = false;
        };
        "${mediaDir}/animes" = {
          hostPath = mediaDir + "/animes";
          isReadOnly = false;
        };
        "${mediaDir}/.downloads" = {
          hostPath = downloadDir;
          isReadOnly = false;
        };
        "/var/lib/sonarr/.config" = {
          hostPath = sonarrDataDir;
          isReadOnly = false;
        };
        "/var/lib/radarr/.config" = {
          hostPath = radarrDataDir;
          isReadOnly = false;
        };
        "/var/lib/private/prowlarr/.config" = {
          hostPath = prowlarrDataDir;
          isReadOnly = false;
        };
        "/var/lib/jackett/.config" = {
          hostPath = jackettDataDir;
          isReadOnly = false;
        };
        "/var/lib/jellyfin" = {
          hostPath = jellyfinDataDir;
          isReadOnly = false;
        };
      };

      config =
        { pkgs, ... }:
        {
          system.stateVersion = "22.11";
          networking.firewall.enable = false;
          systemd.tmpfiles.rules = [
            "d ${builtins.toString mediaDir + "/movies"} 777 radarr media -"
            "d ${builtins.toString mediaDir + "/tv"} 777 sonarr media -"
            "d ${builtins.toString mediaDir + "/animes"} 777 sonarr media -"
            "d ${builtins.toString downloadDir} 777 transmission media -"
          ];

          networking.firewall = {
            allowedTCPPorts = [
              ports.radarr
              ports.sonarr
              ports.prowlarr
              ports.jackett
              ports.transmission
              ports.jellyfin
              ports.flaresolverr
            ];
          };

          users.groups.media = {
            members = [
              "radarr"
              "sonarr"
              "transmission"
              "jellyfin"
            ];
            gid = 3000;
          };

          services.radarr = {
            enable = true;
            group = "media";
            settings = {
              app.theme = "dark";
              auth = {
                methode = "forms";
                required = "enabled";
              };
            };
          };
          services.sonarr = {
            enable = true;
            group = "media";
            settings = {
              app.theme = "dark";
              auth = {
                methode = "forms";
                required = "enabled";
              };
            };
          };
          services.jellyfin = {
            enable = true;
            group = "media";
          };
          services.prowlarr = { #TODO: Fix Me
            enable = true;
            settings = {
              app.theme = "dark";
              auth = {
                methode = "forms";
                required = "enabled";
              };
            };
          };

          services.flaresolverr.enable = true;
          services.jackett.enable = true;

          systemd.services.transmission.serviceConfig = {
            RootDirectoryStartOnly = lib.mkForce null;
            RootDirectory = lib.mkForce null;
          };
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
              rpc-authentication-required = false;
              rpc-username = "binette";
              rpc-password = "cd";
              umask = 18;
              utp-enabled = true;
            };
          };
        };
    };
  };
}
