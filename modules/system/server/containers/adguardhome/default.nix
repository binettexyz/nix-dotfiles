{ pkgs, config, lib, ... }:
with lib;

let
  cfg = config.modules.containers.adGuardHome;
in
{
  options.modules.containers.adGuardHome = {
    enable = mkOption {
      description = "Enable AdGuardHome service";
      type = types.bool;
      default = false;
    };
  };

  config = mkIf (cfg.enable) { 

    networking.nat.internalInterfaces = [ "ve-adguardhome" ];
    networking.firewall.allowedTCPPorts = [ 3000 53 ];
  
    containers.adguardhome = {
      autoStart = true;
  
        # networking & port forwarding
      privateNetwork = false;
  
        # mounts
      bindMounts = {
        "/var/lib/AdGuardHome" = {
				  hostPath = "/nix/persist/var/lib/AdGuardHome";
				  isReadOnly = false;
			  };
      };
  
      forwardPorts = [
  			{
  				containerPort = 3000;
  				hostPort = 3000;
  				protocol = "tcp";
  			}
  			{
  				containerPort = 80;
  				hostPort = 80;
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
        networking.firewall.allowedTCPPorts = [ 3000 ];

        services.adguardhome = {
          enable = true;
#          host = "127.0.0.1";
#          port = 3000;
#          settings = {
#          };
        };
      };
    };
  };

}
