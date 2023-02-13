{ pkgs, config, lib, ... }:
with lib;

let
  cfg = config.modules.containers.nextcloud;
  openPort = toString cfg.openPorts;
  adminPass = config.sops.secrets.nextcloud-adminPass.path;
  dbPass = config.sops.secrets.nextcloud-dbPass.path;
in
{
  options.modules.containers.nextcloud = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
    openPorts = mkOption {
      type = types.port;
      default = 4040;
    };
  };

  config = mkIf (cfg.enable) { 

    networking.nat.internalInterfaces = [ "ve-nextcloud" ];
    networking.firewall.allowedTCPPorts = [ cfg.openPorts ];

    services.nginx.enable = true;
    services.nginx.virtualHosts."nextcloud.box" = {
      listen = [ { addr = "100.71.254.90"; port = cfg.openPorts; } ];
      locations."/" = {
        proxyPass = "http://100.71.254.90:${openPort}";
      };
    };

#    sops.secrets.nextcloud-dbPass = {
#      format = "yaml";
#      sopsFile = ../../secrets.yaml;
#    };
#
#    sops.secrets.nextcloud-adminPass = {
#      format = "yaml";
#        # can be also set per secret
#      sopsFile = ../../secrets.yaml;
#    };

    containers.nextcloud = {
      autoStart = true;
  
        # networking & port forwarding
      privateNetwork = false;
  
        # mounts
#      bindMounts = {
#        "/var/lib/AdGuardHome" = {
#				  hostPath = "/nix/persist/var/lib/AdGuardHome";
#			  isReadOnly = false;
#		  };
#			  "/var/lib/unbound" = {
#				hostPath = "/nix/persist/var/lib/unbound";
#				isReadOnly = false;
#			  };
#      };
  
      forwardPorts = [
        {
				  containerPort = cfg.openPorts;
				  hostPort = cfg.openPorts;
				  protocol = "tcp";
			  }
  		];
  
      config = { config, pkgs, ... }: {

        system.stateVersion = "22.11";
        networking.hostName = "nextcloud";

        networking.firewall.allowedTCPPorts = [ cfg.openPorts ];

        services.postgresql = {
          enable = true;
          ensureUsers = [
            {
              name = "binette";
              ensurePermissions = {
                "DATABASE binette" = "ALL PRIVILEGES";
              };
            }
          ];
          ensureDatabases = [ "binette" ];
        };
      
        services.nextcloud = {
          enable = true;
          hostName = "localhost";
          package = pkgs.nextcloud24;
#          https = true;
          config = {
            dbtype = "pgsql";
            dbname = "binette";
            dbhost = "/run/postgresql";
            dbpassFile = "123"; #"${dbPass}";
#            overwriteProtocol = "https";
            adminuser = "admin";
            adminpassFile = "123"; #"${adminPass}";
          };
        };
      };
    };
  };

}
