{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.modules.server.containers.vaultwarden;
  hostAddress = "192.168.100.1";
  localAddress = "192.168.100.15";
  dataDir = "/nix/persist/srv/container-service-data/vaultwarden";
  backupDir = "/nix/persist/srv/container-service-data/vaultwarden/backup";
  ports.vaultwarden = 8222;
in
{
  options.modules.server.containers.vaultwarden.enable = lib.mkOption {
    description = "Enable vaultwarden passwd manager";
    default = false;
  };

  config = lib.mkIf (cfg.enable) {
    services.nginx.virtualHosts."vault.jbinette.xyz" = {
      useACMEHost = "jbinette.xyz";
      forceSSL = true;
      locations."/" = {
        proxyPass = "http://${localAddress}:" + toString (ports.vaultwarden);
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
      "d ${dataDir} 0750 root root -"
      "d ${backupDir} 0750 root root -"
    ];

    containers.vaultwarden =
      let
        environmentFile = config.sops.secrets."server/containers/vaultwardenAdminToken".path;
      in {
      autoStart = true;
      privateNetwork = true;
      inherit localAddress hostAddress;

      bindMounts = {
        "/var/lib/bitwarden_rs" = {
          hostPath = dataDir;
          isReadOnly = false;
        };
        "/var/lib/bitwarden_rs/backup" = {
          hostPath = backupDir;
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
          allowedTCPPorts = [ ports.vaultwarden ];
          allowedUDPPorts = [ ports.vaultwarden ];
        };
         services.vaultwarden = {
          enable = true;
          environmentFile = "/var/lib/bitwarden_rs/vaultwarden.env";
          config = {
            DOMAIN = "https://vault.jbinette.xyz";
            SIGNUPS_ALLOWED = false;
            ROCKET_ADDRESS = "0.0.0.0";
            ROCKET_PORT = ports.vaultwarden;
            ROCKET_LOG = "critical";
          };
          inherit backupDir;
        };
      };
    };
  };
}

