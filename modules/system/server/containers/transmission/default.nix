{ pkgs, config, lib, ... }:
with lib;

let
  cfg = config.modules.containers.transmission;
in
{
  options.modules.containers.transmission = {
    enable = mkOption {
      description = "Enable transmission services";
      type = types.bool;
      default = false;
    };
  };

  config = mkIf (cfg.enable) {
    networking.nat.internalInterfaces = [ "ve-transmission" ];
    networking.firewall.allowedTCPPorts = [ 9091 ];

    containers.transmission = {
      autoStart = true;
        # starts fresh every time it is updated or reloaded
  #    ephemeral = true;
  
        # networking & port forwarding
      privateNetwork = false;
  #    hostBridge = "br0";
  #    hostAddress = "192.168.100.10";
  #    localAddress = "192.168.100.20";
  
        # mounts
      bindMounts = {
        "/media/downloads/torrents" = {
          hostPath = "/media/downloads/torrents";
          isReadOnly = false;
        };
      };
  
      forwardPorts = [
  			{
  				containerPort = 9091;
  				hostPort = 9091;
  				protocol = "tcp";
  			}
  		];
  
      config = { config, pkgs, ... }: {
  
        system.stateVersion = "22.11";
        networking.hostName = "transmission";
  
        services.transmission = {
          enable = true;
          user = "transmission";
          group = "transmission";
          openFirewall = true;
          settings = {
            download-dir = "/media/downloads/torrents";
            blocklist-enabled = true;
            blocklist-url = "http://list.iblocklist.com/?list=ydxerpxkpcfqjaybcssw&fileformat=p2p&archiveformat=gz";
            encryption = 1;
            incomplete-dir = "/media/downloads/torrents/.incomplete";
            incomplete-dir-enabled = true;
            message-level = 1;
            peer-port = 50778;
            peer-port-random-high = 65535;
            peer-port-random-low = 49152;
            peer-port-random-on-start = true;
            rpc-bind-address = "0.0.0.0";
            rpc-port = 9091;
            rpc-enable = true;
            umask = 18;
            utp-enabled = true;
            rpc-whitelist-enabled = false;
          };
        };
      };
    };
  };

}
