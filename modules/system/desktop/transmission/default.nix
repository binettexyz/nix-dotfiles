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
        "/var/lib/transmission" = {
          hostPath = "/var/lib/transmission";
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
          home = "/var/lib/transmission";
          user = "transmission";
          group = "transmission";
          openFirewall = true;
          settings = {
            blocklist-enabled = true;
            blocklist-url = "http://list.iblocklist.com/?list=ydxerpxkpcfqjaybcssw&fileformat=p2p&archiveformat=gz";
            incomplete-dir-enabled = true;
            watch-dir-enabled = true;
            encryption = 1;
            message-level = 1;
            peer-port = 50778;
            peer-port-random-high = 65535;
            peer-port-random-low = 49152;
            peer-port-random-on-start = true;
            rpc-enable = true;
            rpc-bind-address = "0.0.0.0";
            rpc-port = 9091;
            rpc-authentication-required = false;
            rpc-username = "binette";
            rpc-password = "cd";
            rpc-whitelist-enabled = false;
            umask = 18;
            utp-enabled = true;
          };
        };
      };
    };
  };

}
