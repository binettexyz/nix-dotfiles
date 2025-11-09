{
  config,
  lib,
  pkgs,
  ...
}:
let
  service = "vaultwarden";
  cfg = config.modules.homelab.services.${service};
  hl = config.modules.homelab;
  hostAddress = "192.168.100.1";
  localAddress = "192.168.100.15";
in
{
  options.modules.homelab.services.${service} = {
    enable = lib.mkEnableOption "Enable vaultwarden passwd manager";
    address = {
      host = lib.mkOption {
        type = lib.types.str;
        default = "192.168.100.1";
      };
      local = lib.mkOption {
        type = lib.types.str;
        default = "192.168.100.15";
      };
    };
    backupDir = lib.mkOption {
      type = lib.types.str;
      default = "/nix/persist/srv/container-service-data/vaultwarden/backup";
    };
    dataDir = lib.mkOption {
      type = lib.types.str;
      default = "/nix/persist/srv/container-service-data/vaultwarden";
    };
    url = lib.mkOption {
      type = lib.types.str;
      default = "vault.${hl.baseDomain}";
    };
    port = lib.mkOption {
      type = lib.types.int;
      default = 8222;
    };
  };

  config = lib.mkIf (hl.enable && cfg.enable) {
    services.nginx.virtualHosts.${cfg.url} = {
      useACMEHost = hl.baseDomain;
      forceSSL = true;
      locations."/" = {
        proxyPass = "http://${cfg.address.local}:" + toString (cfg.port);
        proxyWebsockets = true;
        extraConfig = ''
          proxy_set_header Host $host;
          proxy_set_header X-Real-IP $remote_addr;
          proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
          proxy_set_header X-Forwarded-Proto $scheme;
        '';
      };
    };

    sops.secrets."server/containers/vaultwardenAdminToken" = {
      mode = "777";
    };

    systemd.tmpfiles.rules = [
      "d ${cfg.dataDir} 0750 root root -"
      "d ${cfg.backupDir} 0750 root root -"
    ];

    containers.${service} =
      let
        environmentFile = config.sops.secrets."server/containers/vaultwardenAdminToken".path;
      in {
      autoStart = true;
      privateNetwork = true;
      localAddress = cfg.address.local;
      hostAddress = cfg.address.host;

      bindMounts = {
        "/var/lib/bitwarden_rs" = {
          hostPath = cfg.dataDir;
          isReadOnly = false;
        };
        "/var/lib/bitwarden_rs/backup" = {
          hostPath = cfg.backupDir;
          isReadOnly = false;
        };
        "/var/lib/bitwarden_rs/vaultwarden.env" = {
          hostPath = environmentFile;
          isReadOnly = false;
        };
      };

      config = {pkgs, ...}: {
        system.stateVersion = "22.11";
        networking.firewall = {
          allowedTCPPorts = [ cfg.port ];
          allowedUDPPorts = [ cfg.port ];
        };
         services.vaultwarden = {
          enable = true;
          backupDir = cfg.backupDir;
          environmentFile = "/var/lib/bitwarden_rs/vaultwarden.env";
          config = {
            DOMAIN = "https://${cfg.url}";
            SIGNUPS_ALLOWED = false;
            ROCKET_ADDRESS = "0.0.0.0";
            ROCKET_PORT = cfg.port;
            ROCKET_LOG = "critical";
          };
        };
      };
    };
  };
}

