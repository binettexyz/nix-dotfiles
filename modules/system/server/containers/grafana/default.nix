{ pkgs, config, lib, ... }:
with lib;

let
  cfg = config.modules.containers.grafana;
in
{
  options.modules.containers.grafana = {
    enable = mkOption {
      description = "Enable grafana services";
      type = types.bool;
      default = false;
    };
  };

  config = mkIf (cfg.enable) {
    networking.nat.internalInterfaces = [ "ve-grafana" ];
    networking.firewall.allowedTCPPorts = [ 3001 ];
  
    containers.minecraft-server = {
      autoStart = true;
  
        # networking & port forwarding
      privateNetwork = false;
  
      forwardPorts = [
  			{
  				containerPort = 3000;
  				hostPort = 3001;
  				protocol = "tcp";
  			}
  		];
  
      config = { config, pkgs, ... }: {

        networking.firewall.allowedTCPPorts = [ 3000 ];

        services.grafana = {
          enable = true;
#          port = 9000;
#          addr = "127.0.0.1";
        };
      };
    };
  };

}
