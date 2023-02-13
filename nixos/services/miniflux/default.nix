{ pkgs, config, lib, ... }:
with lib;

let
  cfg = config.modules.services.miniflux;
in
{
  options.modules.services.miniflux = {
    enable = mkOption {
      description = "Enable miniflux service";
      type = types.bool;
      default = false;
    };
  };

  config = mkIf (cfg.enable) {
    services.miniflux.enable = true;
  };

}
