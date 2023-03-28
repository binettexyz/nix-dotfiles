{ pkgs, config, lib, ... }:
with lib;

let
  cfg = config.modules.containers.nextcloud;
  localAddress = "172.17.0.4";
  ports.nextcloud = 8383;
  mkLocalProxy = port: {
    locations."/".proxyPass = "http://${localAddress}";
  };
in
{
  options.modules.containers.nextcloud = {
    enable = mkEnableOption "nextcloud";
  };

  config = mkIf (cfg.enable) {

    services.nginx.virtualHosts = {
      "nextcloud.box" = mkLocalProxy ports.nextcloud;
    };

    virtualisation.oci-containers.containers = {
      nextcloud = {
        image = "nextcloud:latest";
        autoStart = true;
#        ports = [
#          "80:${builtins.toString ports.nextcloud}"
#        ];
        volumes = [
	        "/nix/persist/srv/container-service-data/nextcloud/config:/var/www/html/config"
	        "/media/nextcloud:/var/www/html/data"
        ];
      };
    };
  };

}

