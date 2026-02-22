{
  flake.nixosModules.servarr =
    { config, lib, ... }:
    let
      cfg = config.modules.homelab.services.servarr;
      baseDomain = config.my.baseDomain;
      mkProxy = port: {
        useACMEHost = "${baseDomain}";
        forceSSL = true;
        locations."/".proxyPass = "http://${cfg.address.local}:${toString port}";
      };
    in
    {
      options.modules.homelab.services.servarr = {
        enable = lib.mkOption {
          description = "Enable torrents related services";
          default = false;
        };
        address = {
          host = lib.mkOption {
            type = lib.types.str;
            default = "192.168.100.1";
          };
          local = lib.mkOption {
            type = lib.types.str;
            default = "192.168.100.17";
          };
        };
        directories = {
          download = lib.mkOption {
            type = lib.types.str;
            default = "/home/data/library/media/.downloads";
          };
          media = lib.mkOption {
            type = lib.types.str;
            default = "/home/data/library/media/";
          };
          service = {
            sonarr = lib.mkOption {
              type = lib.types.str;
              default = "/nix/persist/srv/sonarr";
            };
            radarr = lib.mkOption {
              type = lib.types.str;
              default = "/nix/persist/srv/radarr";
            };
            prowlarr = lib.mkOption {
              type = lib.types.str;
              default = "/nix/persist/srv/prowlarr";
            };
            jackett = lib.mkOption {
              type = lib.types.str;
              default = "/nix/persist/srv/jackett";
            };
          };
        };
        ports = {
          sonarr = lib.mkOption {
            type = lib.types.int;
            default = 8989;
          };
          radarr = lib.mkOption {
            type = lib.types.int;
            default = 7878;
          };
          prowlarr = lib.mkOption {
            type = lib.types.int;
            default = 9696;
          };
          jackett = lib.mkOption {
            type = lib.types.int;
            default = 9117;
          };
          transmission = lib.mkOption {
            type = lib.types.int;
            default = 9091;
          };
          flaresolverr = lib.mkOption {
            type = lib.types.int;
            default = 8191;
          };
        };
      };

      config = lib.mkIf cfg.enable {
        services.nginx.virtualHosts = {
          "sonarr.${baseDomain}" = mkProxy cfg.ports.sonarr;
          "radarr.${baseDomain}" = mkProxy cfg.ports.radarr;
          "jackett.${baseDomain}" = mkProxy cfg.ports.jackett;
          "prowlarr.${baseDomain}" = mkProxy cfg.ports.prowlarr;
          "trans.${baseDomain}" = mkProxy cfg.ports.transmission;
        };

        systemd.tmpfiles.rules = [
          "d ${cfg.directories.service.sonarr} - - - -"
          "d ${cfg.directories.service.radarr} - - - -"
          "d ${cfg.directories.service.prowlarr} - - - -"
          "d ${cfg.directories.service.jackett} - - - -"
        ];

        # ---Main container---
        containers.servarr = {
          autoStart = true;
          privateNetwork = true;
          localAddress = cfg.address.local;
          hostAddress = cfg.address.host;

          bindMounts = {
            "${cfg.directories.media}/movies" = {
              hostPath = "${cfg.directories.media}/movies";
              isReadOnly = false;
            };
            "${cfg.directories.media}/tv" = {
              hostPath = "${cfg.directories.media}/tv";
              isReadOnly = false;
            };
            "${cfg.directories.media}/animes" = {
              hostPath = "${cfg.directories.media}/animes";
              isReadOnly = false;
            };
            "${cfg.directories.media}/.downloads" = {
              hostPath = cfg.directories.download;
              isReadOnly = false;
            };
            "/var/lib/sonarr/.config" = {
              hostPath = cfg.directories.service.sonarr;
              isReadOnly = false;
            };
            "/var/lib/radarr/.config" = {
              hostPath = cfg.directories.service.radarr;
              isReadOnly = false;
            };
            "/var/lib/private/prowlarr/.config" = {
              hostPath = cfg.directories.service.prowlarr;
              isReadOnly = false;
            };
            "/var/lib/jackett/.config" = {
              hostPath = cfg.directories.service.jackett;
              isReadOnly = false;
            };
          };

          config = {
            system.stateVersion = "25.11";
            systemd.tmpfiles.rules = [
              "d ${cfg.directories.media}/movies 777 radarr media -"
              "d ${cfg.directories.media}/tv 777 sonarr media -"
              "d ${cfg.directories.media}/animes 777 sonarr media -"
              "d ${cfg.directories.media}/tv-sonarr 777 transmission media -"
            ];

            networking.firewall = {
              enable = false;
              allowedTCPPorts = [
                cfg.ports.radarr
                cfg.ports.sonarr
                cfg.ports.prowlarr
                cfg.ports.jackett
                cfg.ports.transmission
                cfg.ports.flaresolverr
              ];
            };

            users.groups.media = {
              members = [
                "radarr"
                "sonarr"
                "transmission"
              ];
              gid = 3000;
            };

            services.radarr = {
              enable = true;
              group = "media";
              openFirewall = true;
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
              openFirewall = true;
              settings = {
                app.theme = "dark";
                auth = {
                  methode = "forms";
                  required = "enabled";
                };
              };
            };
            services.prowlarr = {
              # TODO: Fix Me
              enable = true;
              openFirewall = true;
              settings = {
                app.theme = "dark";
                auth = {
                  methode = "forms";
                  required = "enabled";
                };
              };
            };

            services.flaresolverr.enable = true;
            services.jackett = {
              enable = true;
              openFirewall = true;
            };

            systemd.services.transmission.serviceConfig = {
              RootDirectoryStartOnly = lib.mkForce null;
              RootDirectory = lib.mkForce null;
            };
            services.transmission = {
              enable = true;
              group = "media";
              openFirewall = true;
              settings = {
                blocklist-enabled = true;
                blocklist-url = "http://list.iblocklist.com/?list=ydxerpxkpcfqjaybcssw&fileformat=p2p&archiveformat=gz";
                download-dir = cfg.directories.download;
                incomplete-dir-enabled = true;
                incomplete-dir = "${cfg.directories.download}/.incomplete";
                encryption = 1;
                message-level = 1;
                peer-port = 50778;
                peer-port-random-high = 65535;
                peer-port-random-low = 49152;
                peer-port-random-on-start = true;
                rpc-enable = true;
                rpc-bind-address = "0.0.0.0";
                rpc-port = cfg.ports.transmission;
                rpc-whitelist-enabled = false;
                rpc-authentication-required = false;
                rpc-username = "binette";
                rpc-password = "cd";
                umask = 18;
                utp-enabled = true;
              };
            };

            networking.useHostResolvConf = lib.mkForce false;
            services.resolved.enable = true;
          };

        };
      };
    };
}
