{ pkgs, config, lib, ... }:
with lib;

let
  cfg = config.modules.containers.adGuardHome;
  adguardPort = toString cfg.openPorts;
in
{
  options.modules.containers.adGuardHome = {
    enable = mkOption {
      description = "Enable AdGuardHome service";
      type = types.bool;
      default = false;
    };
    openPorts = mkOption {
      type = types.port;
      default = 8001;
    };
  };

  config = mkIf (cfg.enable) { 

    networking.nat.internalInterfaces = [ "ve-adguardhome" ];
    networking.firewall.allowedTCPPorts = [ 8001 3000 53 ];

  # TODO not working 
#    services.nginx.enable = true;
#    services.nginx.virtualHosts."adguard.box" = {
#        locations."/" = {
#          proxyPass = "http://100.71.254.90:${adguardPort}";
#        };
#    };

    containers.adguardhome = {
      autoStart = true;
  
        # networking & port forwarding
      privateNetwork = false;
  
        # mounts
#      bindMounts = {
#        "/var/lib/AdGuardHome" = {
#				  hostPath = "/nix/persist/var/lib/AdGuardHome";
#				  isReadOnly = false;
#			  };
#        "/var/lib/private/AdGuardHome" = {
#				  hostPath = "/nix/persist/var/lib/private/AdGuardHome";
#				  isReadOnly = false;
#			  };
#      };
  
      forwardPorts = [
        {
				  containerPort = 3000;
				  hostPort = 3000;
				  protocol = "tcp";
			  }
        {
				  containerPort = 8001;
				  hostPort = 8001;
				  protocol = "tcp";
			  }
        {
				  containerPort = 53;
				  hostPort = 53;
				  protocol = "tcp";
			  }
			  {
				  containerPort = 53;
				  hostPort = 53;
				  protocol = "udp";
			  }
  		];
  
      config = { config, pkgs, ... }: {

        system.stateVersion = "22.11";
        networking.hostName = "adguardhome";

        services.adguardhome = {
          enable = true;
          openFirewall = true;
          host = "127.0.0.1";
          port = 3000;
#          settings = {
#            bind_host = "100.71.254.90";
#            bind_port = cfg.openPorts;
#            dns = {
#              rewrites = {
#                domain = "'*.box'";
#                answer = "100.71.254.90";
#              };
#            };
#          };
        };
      };
    };
  };

}
