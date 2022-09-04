{ pkgs, config, lib, ... }:
with lib;

let
  cfg = config.modules.services.redshift;
in
{
  options.modules.services.redshift = {
    enable = mkOption {
      description = "Enable redshift service";
      type = types.bool;
      default = false;
    };
  };

  config = mkIf (cfg.enable) {

    services.redshift = {
      enable = true;
      latitude = "45.35";
      longitude = "-73.30";
      dawnTime = null;
      duskTime = null;
      temperature = {
        day = 6500;
        night = 3800;
      };
    };
  };

}
