{ pkgs, config, lib, ... }:
with lib;

let
  cfg = config.modules.containers.jellyfin;
in
{
  options.modules.containers.jellyfin= {
    enable = mkOption {
      description = "Enable jellyfin services";
      type = types.bool;
      default = false;
    };
  };

  config = mkIf (cfg.enable) {
    networking.nat.internalInterfaces = [ "ve-jellyfin" ];
    networking.firewall.allowedTCPPorts = [ 8096 ];
  
    containers.jellyfin= {
      autoStart = true;
  
        # networking & port forwarding
      privateNetwork = false;
  
        # mounts
      bindMounts = {
        "/media/videos" = {
          hostPath = "/media/videos";
          isReadOnly = false;
        };
  
      };
  
      forwardPorts = [
  			{
  				containerPort = 8096;
  				hostPort = 8096;
  				protocol = "tcp";
  			}
  		];
  
      config = { config, pkgs, ... }:
      let
        unstable = import (builtins.fetchTarball "https://github.com/NixOS/nixpkgs/archive/refs/heads/nixos-unstable.tar.gz") {
          config = config.nixpkgs.config;
        };
      in {
        system.stateVersion = "22.11";
        networking.hostName = "jellyfin";

        environment.systemPackages = with pkgs; [ unstable.jellyfin ];
  
        services.jellyfin= {
          enable = true;
          user = "jellyfin";
          group = "jellyfin";
          openFirewall = true;
        };
      };
    };
  };

}
