{
  config,
  pkgs,
  lib,
  ...
}:
let
  service = "sonarr";
  cfg = config.modules.homelab.services.${service};
  hl = config.modules.homelab;
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
        default = "192.168.100.17";
      };
    };
    directories = {
      data = lib.mkOption {
        type = lib.types.str;
        default = "/nix/persist/srv/container-service-data/sonarr";
      };
      media = lib.mkOption {
        type = lib.types.str;
        default = "/data/library/media";
      };
    };
    ports = {
      sonarr = lib.mkOption {
        type = lib.types.int;
        default = 8989;
      };
      flaresolverr = lib.mkOption {
        type = lib.types.int;
        default = 8191;
      };
    };
    url = lib.mkOption {
      type = lib.types.str;
      default = "sonarr.${hl.baseDomain}";
    };
  };

  config = lib.mkIf (hl.enable && cfg.enable) {
    services.nginx.virtualHosts.${cfg.url} = {
      useACMEHost = hl.baseDomain;
      forceSSL = true;
      locations."/" = {
        proxyPass = "https://${cfg.address.local}:" + toString (cfg.ports.sonarr);
      };
    };

    systemd.tmpfiles.rules = [
      "d ${cfg.directories.data} - - - -"
    ];

    containers.${service} = {
      autoStart = true;
      privateNetwork = true;
      localAddress = cfg.address.local;
      hostAddress = cfg.address.host;

      bindMounts = {
        "${cfg.directories.media}/tv" = {
          hostPath = cfg.directories.media + "/tv";
          isReadOnly = false;
        };
        "${cfg.directories.media}/animes" = {
          hostPath = cfg.directories.media + "/animes";
          isReadOnly = false;
        };
        "/var/lib/sonarr/.config" = {
          hostPath = cfg.directories.data;
          isReadOnly = false;
        };
      };

      config =
        { pkgs, ... }:
        {
          system.stateVersion = "22.11";
          networking.firewall.enable = false;
          systemd.tmpfiles.rules = [
            "d ${builtins.toString cfg.directories.media + "/tv"} 777 sonarr media -"
            "d ${builtins.toString cfg.directories.media + "/animes"} 777 sonarr media -"
          ];

          networking.firewall = {
            allowedTCPPorts = [
              cfg.ports.sonarr
              cfg.ports.flaresolverr
            ];
          };

          users.groups.media = {
            members = [ "sonarr" ];
            gid = 3000;
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

          services.flaresolverr.enable = true;
        };
    };
  };
}
