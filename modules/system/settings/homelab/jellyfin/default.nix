{
  flake.nixosModules.jellyfin =
    { config, lib, ... }:
    let
      service = "jellyfin";
      cfg = config.modules.homelab.services.${service};
      baseDomain = config.my.baseDomain;
    in
    {
      options.modules.homelab.services.${service} = {
        enable = lib.mkEnableOption "Enable ${service}";
        address = {
          host = lib.mkOption {
            type = lib.types.str;
            default = "192.168.100.1";
          };
          local = lib.mkOption {
            type = lib.types.str;
            default = "192.168.100.19";
          };
        };
        downloadDir = lib.mkOption {
          type = lib.types.str;
          default = "/home/data/library/media/.downloads";
        };
        mediaDir = lib.mkOption {
          type = lib.types.str;
          default = "/home/data/library/media";
        };
        ports.jellyfin = lib.mkOption {
          type = lib.types.int;
          default = 8096;
        };
        serviceDir = lib.mkOption {
          type = lib.types.str;
          default = "/nix/persist/srv/${service}";
        };
        url = lib.mkOption {
          type = lib.types.str;
          default = "streaming.${baseDomain}";
        };
      };

      config = lib.mkIf cfg.enable {
        services.nginx.virtualHosts."${cfg.url}" = {
          useACMEHost = baseDomain;
          forceSSL = true;
          locations."/".proxyPass = "http://${cfg.address.local}:${toString cfg.ports.jellyfin}";
        };

        networking.firewall.allowedTCPPorts = [
          cfg.ports.jellyfin
        ];

        systemd.tmpfiles.rules = [
          "d ${cfg.serviceDir} - - - -"
        ];

        containers.${service} = {
          autoStart = true;
          privateNetwork = true;
          localAddress = cfg.address.local;
          hostAddress = cfg.address.host;

          forwardPorts = [
            {
              containerPort = cfg.ports.jellyfin;
              hostPort = cfg.ports.jellyfin;
              protocol = "tcp";
            }
          ];

          bindMounts = {
            "${cfg.mediaDir}/movies" = {
              hostPath = "${cfg.mediaDir}/movies";
              isReadOnly = false;
            };
            "${cfg.mediaDir}/tv" = {
              hostPath = "${cfg.mediaDir}/tv";
              isReadOnly = false;
            };
            "${cfg.mediaDir}/animes" = {
              hostPath = "${cfg.mediaDir}/animes";
              isReadOnly = false;
            };
            "/var/lib/jellyfin" = {
              hostPath = cfg.serviceDir;
              isReadOnly = false;
            };
          };

          config = {
            system.stateVersion = "25.05";

            systemd.tmpfiles.rules = [
              "d ${cfg.mediaDir}/movies 777 - media -"
              "d ${cfg.mediaDir}/tv 777 - media -"
              "d ${cfg.mediaDir}/animes 777 - media -"
            ];

            users.groups.media = {
              members = [
                "jellyfin"
              ];
              gid = 3000;
            };

            services.${service} = {
              enable = true;
              group = "media";
              openFirewall = true;
              dataDir = "/var/lib/${service}";
            };
          };
        };
      };
    };
}
