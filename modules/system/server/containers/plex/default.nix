{ pkgs, config, lib, ... }:
with lib;

let
  cfg = config.modules.containers.plex;
in
{
  options.modules.containers.plex = {
    enable = mkOption {
      description = "Enable plex services";
      type = types.bool;
      default = false;
    };
  };

  config = mkIf (cfg.enable) {
    networking.nat.internalInterfaces = [ "ve-plex" ];
    networking.firewall.allowedTCPPorts = [ 32400 80 443 ];
  
    containers.plex = {
      autoStart = true;
        # starts fresh every time it is updated or reloaded
  #    ephemeral = true;
  
        # networking & port forwarding
      privateNetwork = false;
  #    hostBridge = "br0";
  #    hostAddress = "192.168.100.12";
  #    localAddress = "192.168.100.22";
  
        # mounts
      bindMounts = {
        "/var/lib/plex" = {
          hostPath = "/nix/persist/var/lib/plex";
          isReadOnly = false;
        };        
        "/media/videos" = {
          hostPath = "/media/videos";
          isReadOnly = false;
        };
  
      };
  
      forwardPorts = [
  			{
  				containerPort = 32400;
  				hostPort = 32400;
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
        networking.hostName = "plex";
  
        nixpkgs.config.allowUnfree = true;
        environment.systemPackages = with pkgs; [ unstable.plex ];
  
        services.plex = {
          enable = true;
          user = "plex";
          group = "plex";
          openFirewall = true;
        };
  
        systemd.tmpfiles.rules = [
          "d /var/lib/plex 700 plex plex -"
        ];
      };
    };
  };

}
