{ config, options, lib, pkgs, ... }:
with lib;
let
  cfg = config.modules.containers.vaultwarden;
  localAddress = "10.0.0.16";
  hostAddress = "10.0.1.16";
  backupDir = "/nix/persist/srv/private/vaultwarden";
  ports.vaultwarden = 3011;
  mkLocalProxy = port: {
    locations."/".proxyPass = "http://localhost:" + toString(port);
#    locations."/".proxyPass = "http://${localAddress}:" + toString(port);
  };
in
{
  options.modules.containers.vaultwarden = {
    enable = mkEnableOption "vaultwarden";
  };

  config = mkIf cfg.enable {
    services.nginx.virtualHosts = {
      "vault.box" = mkLocalProxy ports.vaultwarden;
    };

    containers.vaultwarden = {
      autoStart = true;
      ephemeral = true;

      privateNetwork = false;
      inherit localAddress hostAddress;
  
      bindMounts = { "${backupDir}" = { hostPath = "/nix/persist/srv/private/vaultwardenBackup"; isReadOnly = false; }; };
  
      forwardPorts = [
        {
          containerPort = ports.vaultwarden;
          hostPort = ports.vaultwarden;
          protocol = "tcp";
        }
  		];
  
      config = { config, pkgs, ... }: {
        networking.firewall = {
          allowedTCPPorts = [ ports.vaultwarden ];
        };

        services.vaultwarden = {
          enable = true;
          config = {
            webVaultEnabled = true;
            websocketEnabled = true;
            signupsVerify = false;
            websocketAddress = "0.0.0.0";
            rocketAddress = "0.0.0.0";
            rocketPort = ports.vaultwarden;
            logFile = "/var/log/bitwarden_rs.log";
            showPasswordHint = false;
          };
          inherit backupDir;
        };
    
        system.activationScripts.initVaultwarden = ''
          mkdir -p "${backupDir}"
          chown vaultwarden "${backupDir}"
        '';
    

        system.stateVersion = "22.11";
      };
    };
  };

}
