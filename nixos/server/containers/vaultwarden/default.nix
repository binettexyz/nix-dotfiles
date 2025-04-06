{ config, options, lib, pkgs, ... }:
with lib;
let
  cfg = config.modules.server.containers.vaultwarden.enable;
  localAddress = "10.0.0.16";
  hostAddress = "10.0.1.16";
  backupDir = "/nix/persist/srv/private/vaultwarden";
  ports.vaultwarden = 8222;
in
{
  options.modules.server.containers.vaultwarden.enable = mkOption {
    description = "Enable vaultwarden passwd manager";
    default = false;
  };

  config = lib.mkIf config.modules.server.containers.vaultwarden.enable {

    containers.vaultwarden = {
      autoStart = true;
      ephemeral = false;

      privateNetwork = false;
      inherit localAddress hostAddress;
  
      bindMounts = { "${backupDir}" = { hostPath = "/nix/persist/srv/private/vaultwardenBackup"; isReadOnly = false; }; };
  
      forwardPorts = [
        {
          containerPort = ports.vaultwarden;
          hostPort = ports.vaultwarden;
          protocol = "tcp";
        }
        {
          containerPort = ports.vaultwarden;
          hostPort = ports.vaultwarden;
          protocol = "udp";
        }
  		];
  
      config = { config, pkgs, ... }: {
        networking.firewall = {
          allowedTCPPorts = [ ports.vaultwarden ];
          allowedUDPPorts = [ ports.vaultwarden ];
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
