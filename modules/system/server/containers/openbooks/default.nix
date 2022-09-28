{ config, pkgs, lib, ... }:
let
  cfg = config.modules.containers.openbooks;
in
{

  options.modules.containers.openbooks = {
    enable = mkOption {
      description = "Enable openbooks services";
      type = types.bool;
      default = false;
    };
  };

  config = mkIf (cfg.enable) { 

    networking.nat.internalInterfaces = [ "ve-openbooks" ];
    networking.firewall.allowedTCPPorts = [ 8081 ];
  
    virtualisation.oci-containers.containers.openbooks = {
      autoStart = true;
      image = "evanbuss/openbooks";
      ports = [
        "8080:8081"
      ];
      volumes = [
      ];
    };
  };
}
