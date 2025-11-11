{config, lib, ...}:
let
  service = "immich";
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
          default = "192.168.100.16";
        };
      };
      mediaDir = lib.mkOption {
        type = lib.types.str;
        default = "/data/library/photos";
      };
      port = lib.mkOption {
        type = lib.types.int;
        default = 2283;
      };
      url = lib.mkOption {
        type = lib.types.str;
        default = "photo.${hl.baseDomain}";
      };
    };

    config = lib.mkIf (hl.enable && cfg.enable) {
      services.nginx.virtualHosts.${cfg.url} = {
        useACMEHost = hl.baseDomain;
        forceSSL = true;
        locations."/".proxyPass = "http://${cfg.address.local}:${toString cfg.port}";
      };

      containers.${service} = {
        autoStart = true;
        privateNetwork = true;
        localAddress = cfg.address.local;
        hostAddress = cfg.address.host;

        bindMounts = {
          "/var/lib/${service}" = {
            hostPath = cfg.mediaDir;
            isReadOnly = false;
          };
        };

        config = {...}: {
          system.stateVersion = "25.05";
          networking.firewall.allowedTCPPorts = [cfg.port];
          nixpkgs.config.allowUnsupportedSystem = true;

          systemd.tmpfiles.rules = [
            "d /var/lib/${service} 777 immich immich -"
          ];

          services.${service} = {
            enable = true;
            port = cfg.port;
            host = "0.0.0.0";
            mediaLocation = "/var/lib/${service}";
            machine-learning.enable = false;
          };

        };
      };
    };
  }
