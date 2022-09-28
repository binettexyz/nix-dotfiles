{ config, pkgs, lib, ... }:
let
  cfg = config.modules.containers.adGuardHome;
in
{

  options.modules.containers.homer = {
    enable = mkOption {
      description = "Enable Homer dashboard";
      type = types.bool;
      default = false;
    };
  };

  config = mkIf (cfg.enable) { 

    networking.nat.internalInterfaces = [ "ve-homer" ];
    networking.firewall.allowedTCPPorts = [ 8080 ];
  
    virtualisation.oci-containers.containers.homer = {
      autoStart = true;
      image = "b4bz/homer";
      ports = [
        "8080:8080"
      ];
      volumes = [
        "${configFile}:/www/assets/config.yml"
        "${cssFile}:/www/assets/custom.css"
        "./etc:/www/assets/logo"
      ];
    };
  };
}
