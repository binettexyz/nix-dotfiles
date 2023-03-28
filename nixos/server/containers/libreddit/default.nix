{ config, pkgs, lib, ... }:
with lib;
let
  cfg = config.modules.containers.libreddit;
  hostAddress = "10.0.0.1";
  localAddress = "10.0.1.1";
  ports = {
    libreddit = 8100;
  };
  mkLocalProxy = port: {
    locations."/".proxyPass = "http://${localAddress}:" + toString(port);
  };
in
{
  options.modules.containers.libreddit = {
    enable = mkEnableOption "libreddit";
  };

  config = mkIf (cfg.enable) {
    services.nginx.virtualHosts = {
      "libreddit.box" = mkLocalProxy ports.libreddit;
    };

#    systemd.tmpfiles.rules = [
#      "d ${libredditDataDir} - - - -"
#    ];
  
    /*  ---Main container--- */
    containers.libreddit = {
      ephemeral = false;
      autoStart = true;
  
      privateNetwork = true;
      inherit localAddress hostAddress;
  
#      bindMounts = {
#        "" = { hostPath = libredditDataDir; isReadOnly = false; };
#      };

      config = { pkgs, ... }: {
#        networking.firewall.enable = false;

        services.libreddit = {
          enable = true;
          port = 8100;

        networking.firewall.allowedTCPPorts = [ ports.libreddit ];

        system.stateVersion = "22.11";
      };
    };
  };
}
