{ pkgs, config, lib, ... }:
with lib;

let
  cfg = config.modules.transmission;
in
{
  options.modules.transmission = {
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
        "/home/binette/downloads/torrents" = {
          hostPath = "/home/binette/downloads/torrents";
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
            download-dir = "/home/binette/downloads/torrents";
            blocklist-enabled = true;
            blocklist-url = "http://list.iblocklist.com/?list=ydxerpxkpcfqjaybcssw&fileformat=p2p&archiveformat=gz";
            encryption = 1;
            incomplete-dir-enabled = true;
            incomplete-dir = "/home/binette/downloads/torrents/.incomplete";
            message-level = 1;
            peer-port = 50778;
            peer-port-random-high = 65535;
            peer-port-random-low = 49152;
            peer-port-random-on-start = true;
            rpc-bind-address = "0.0.0.0";
            rpc-port = 9091;
            rpc-enable = true;
            rpc-authentication-required = false;
            rpc-username = "binette";
            rpc-password = "cd";
            umask = 18;
            utp-enabled = true;
            rpc-whitelist-enabled = false;
          };
        };
      };
    };
  };

}
