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

    virtualisation.oci-containers.containers = {
      portainer = {
        image = "linuxserver/plex:latest";
        autoStart = true;
        ports = [
          "32400:32400"
        ];
        volumes = [
          "/media/videos:/media/videos"
        ];
      };
    };
  };

}
