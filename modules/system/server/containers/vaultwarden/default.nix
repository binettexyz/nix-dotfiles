{ config, options, lib, pkgs, ... }:
with lib;
let
  cfg = config.modules.containers.vaultwarden;
in
{
  options.modules.containers.vaultwarden = {
    enable = mkEnableOption "vaultwarden";
    backupDir = mkOption {
      type = types.path;
      default = "/nix/persist/srv/private/vaultwarden";
    };
    openPorts = mkOption {
      type = types.port;
      default = 3011;
    };
  };

  config = mkIf cfg.enable {

    networking.nat.internalInterfaces = [ "ve-vaultwarden" ];
    networking.firewall.allowedTCPPorts = [ cfg.openPorts ];

    services.nginx.enable = true;
    services.nginx.virtualHosts."vault.lan" = {
      locations."/" = {
        proxyPass = "http://localhost:3011";
#        proxyWebsockets = true;
      };
    };
  
    containers.vaultwarden = {
      autoStart = true;
        # networking & port forwarding
      privateNetwork = false;
  
        # mounts
      bindMounts = {
        "${cfg.backupDir}" = {
				  hostPath = "/nix/persist/srv/private/vaultwarden";
				  isReadOnly = false;
			  };
      };
  
      forwardPorts = [
        {
          containerPort = cfg.openPorts;
          hostPort = cfg.openPorts;
          protocol = "tcp";
        }
  		];
  
      config = { config, pkgs, ... }: {

        system.stateVersion = "22.11";
        networking.hostName = "vaultwarden";

        services.vaultwarden = {
          enable = true;
          config = {
            webVaultEnabled = true;
            websocketEnabled = true;
            signupsVerify = false;
            websocketAddress = "0.0.0.0";
            rocketAddress = "127.0.0.1";
            rocketPort = 3011;
            logFile = "/var/log/bitwarden_rs.log";
            showPasswordHint = false;
          };
          inherit (cfg) backupDir;
        };
    
#        system.activationScripts.initVaultwarden = ''
#          mkdir -p "${cfg.backupDir}"
#          chown "${config.users.users.vaultwarden.name}" "${cfg.backupDir}"
#        '';
    
        networking.firewall = {
          allowedTCPPorts = [ cfg.openPorts ];
        };
      };
    };
  };

}
