{ config, pkgs, lib, ... }:
with lib;
let
  cfg = config.modules.containers.invidious;
  hostAddress = "10.0.0.1";
  localAddress = "10.0.1.1";
  ports = {
    invidious = 8096;
  };
  mkLocalProxy = port: {
    locations."/".proxyPass = "http://${localAddress}:" + toString(port);
  };
in
{
  options.modules.containers.invidious = {
    enable = mkEnableOption "invidious";
  };

  config = mkIf (cfg.enable) {
    services.nginx.virtualHosts = {
      "invidious.box" = mkLocalProxy ports.jellyfin;
    };

#    systemd.tmpfiles.rules = [
#      "d ${invidiousDataDir} - - - -"
#    ];
  
    /*  ---Main container--- */
    containers.invidious = {
      ephemeral = false;
      autoStart = true;
  
      privateNetwork = false;
      inherit localAddress hostAddress;
  
#      bindMounts = {
#        "" = { hostPath = invidiousDataDir; isReadOnly = false; };
#      };

      config = { pkgs, ... }: {
#        networking.firewall.enable = false;

        networking.firewall.allowedTCPPorts = [ ports.invidious ];

        system.stateVersion = "22.11";
      };
    };
  };
}
