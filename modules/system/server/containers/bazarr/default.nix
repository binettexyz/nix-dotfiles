{ pkgs, config, lib, ... }:
with lib;

let
  cfg = config.modules.containers.bazarr;
in
{
  options.modules.containers.bazarr = {
    enable = mkOption {
      description = "Enable bazarr services";
      type = types.bool;
      default = false;
    };
  };

  config = mkIf (cfg.enable) {
    networking.nat.internalInterfaces = [ "ve-bazarr" ];
    networking.firewall.allowedTCPPorts = [ 6767 ];

    containers.bazarr = {
      autoStart = true;
        # starts fresh every time it is updated or reloaded
#      ephemeral = true;
  
        # networking & port forwarding
      privateNetwork = false;
#      hostBridge = "br0";
#      hostAddress = "192.168.100.10";
#      localAddress = "192.168.100.20";
  
        # mounts
      bindMounts = {
        "/media/videos" = {
          hostPath = "/media/videos";
          isReadOnly = false;
        };
        "/media/downloads/torrents" = {
          hostPath = "/media/downloads/torrents";
          isReadOnly = false;
        };
      };
  
      forwardPorts = [
  			{
  				containerPort = 6767;
  				hostPort = 6767;
  				protocol = "tcp";
  			}
  		];
  
  
      config = { config, pkgs, ... }: {
  
        system.stateVersion = "22.11";
        networking.hostName = "sonarr";
  
      nixpkgs.config.allowUnfree = true;
  
        services.bazarr = {
          enable = true;
          user = "bazarr";
          group = "bazarr";
          openFirewall = true;
        };
      };
    };
  };

}
