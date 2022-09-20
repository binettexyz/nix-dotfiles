{ pkgs, config, lib, ... }:
with lib;

let
  cfg = config.modules.containers.home-assistant;
in
{
  options.modules.containers.home-assistant = {
    enable = mkOption {
      description = "Enable home-assistant service";
      type = types.bool;
      default = false;
    };
  };

  config = mkIf (cfg.enable) { 

    networking.nat.internalInterfaces = [ "ve-hass" ];
    networking.firewall.allowedTCPPorts = [ 8123 ];
  
    containers.hass = {
      autoStart = true;
  
        # networking & port forwarding
      privateNetwork = false;
  
        # mounts
      bindMounts = {
        "/var/lib/hass" = {
				  hostPath = "/nix/persists/var/lib/hass";
				  isReadOnly = false;
			  };
      };
  
      forwardPorts = [
  			{
  				containerPort = 8123;
  				hostPort = 8123;
  				protocol = "tcp";
  			}
  		];
  
      config = { config, pkgs, ... }: {

        system.stateVersion = "22.11";
        networking.hostName = "hass";

        services.home-assistant = {
          enable = true;
          openFirewall = true;
          configDir = "/var/lib/hass";

          config = {
            http.server_port = 8123;
            http.server_host = "127.0.0.1";
          };
        };

      };
    };
  };

}
