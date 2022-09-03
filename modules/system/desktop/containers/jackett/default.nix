{ pkgs, config, lib, ... }:
with lib;

let
  cfg = config.modules.containers.jackett;
in
{
  options.modules.containers.jackett = {
    enable = mkOption {
      description = "Enable jackett services";
      type = types.bool;
      default = false;
    };
  };

  config = mkIf (cfg.enable) {
    networking.nat.internalInterfaces = [ "ve-jackett" ];
    networking.firewall.allowedTCPPorts = [ 9117 ];

    containers.jackett = {
      autoStart = true;
        # starts fresh every time it is updated or reloaded
  #    ephemeral = true;
  
        # networking & port forwarding
      privateNetwork = false;
  #    hostBridge = "br0";
  #    hostAddress = "192.168.100.13";
  #    localAddress = "192.168.100.23";
  
        # mounts
      bindMounts = {
        "/var/lib/jackett/.config/Jackett" = {
          hostPath = "/nix/persist/var/lib/jackett/.config/Jackett";
          isReadOnly = false;
        };        
      };
  
      forwardPorts = [
  			{
  				containerPort = 9117;
  				hostPort = 9117;
  				protocol = "tcp";
  			}
  		];
  
      config = { config, pkgs, ... }: {
  
        system.stateVersion = "22.05";
        networking.hostName = "jackett";
  
        services.jackett = {
          enable = true;
          package = pkgs.jackett;
          user = "jackett";
          group = "jackett";
          openFirewall = true;
        };
  
        systemd.tmpfiles.rules = [
          "d /var/lib/jackett/.config/Jackett 700 jackett jackett -"
        ];
      };
    };
  };

}
