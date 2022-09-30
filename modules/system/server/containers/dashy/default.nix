{ config, pkgs, lib, ... }:
with lib;
let
#  sonarrAPI = builtins.readFile /home/binette/documents/sonarrAPI;
#  radarrAPI = builtins.readFile /home/binette/documents/radarrAPI;
  cfg = config.modules.containers.dashy;
  openPort = toString cfg.openPorts;
in
{

  options.modules.containers.dashy = {
    enable = mkEnableOption "dashy";
    openPorts = mkOption {
      type = types.port;
      default = 8081;
    };
  };

  config = mkIf (cfg.enable) { 

    networking.nat.internalInterfaces = [ "ve-dashy" ];
    networking.firewall.allowedTCPPorts = [ cfg.openPorts ];

    services.nginx.enable = true;
    services.nginx.virtualHosts."dashy.box" = {
      locations."/" = {
        proxyPass = "http://localhost:${openPort}";
      };
    };

    virtualisation.oci-containers.containers.dashy = {
      autoStart = true;
      image = "lissy93/dashy";
      ports = [
        "8081:8081"
      ];
#      volumes = [
#        "${configFile}:/www/assets/config.yml"
#        "${cssFile}:/www/assets/custom.css"
#        "/etc/nixos/modules/system/server/containers/dashy/etc/logo:/www/assets/logo"
#      ];
    };
  };
}
