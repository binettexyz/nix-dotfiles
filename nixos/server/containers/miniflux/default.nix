{ config, pkgs, lib, ... }:
with lib;
let
  cfg = config.modules.containers.miniflux;
  hostAddress = "10.0.0.1";
  localAddress = "10.0.1.1";
  ports = {
    miniflux = 8096;
  };
  mkLocalProxy = port: {
    locations."/".proxyPass = "http://${localAddress}:" + toString(port);
  };
in
{
  options.modules.containers.miniflux = {
    enable = mkEnableOption "miniflux";
  };

  config = mkIf (cfg.enable) {
    services.nginx.virtualHosts = {
      "miniflux.box" = mkLocalProxy ports.jellyfin;
    };

#    systemd.tmpfiles.rules = [
#      "d ${minifluxDataDir} - - - -"
#    ];
  
    /*  ---Main container--- */
    containers.miniflux = {
      ephemeral = false;
      autoStart = true;
  
      privateNetwork = false;
      inherit localAddress hostAddress;
  
#      bindMounts = {
#        "" = { hostPath = minifluxDataDir; isReadOnly = false; };
#      };

      config = { pkgs, ... }: {
#        networking.firewall.enable = false;

        networking.firewall.allowedTCPPorts = [ ports.miniflux ];

        system.stateVersion = "22.11";
      };
    };
  };
}
