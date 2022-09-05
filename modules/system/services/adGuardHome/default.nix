{ pkgs, config, lib, ... }:
with lib;

let
  cfg = config.modules.services.adguardhome;
in
{
  options.modules.services.adguardhome = {
    enable = mkOption {
      description = "Enable adguardhome service";
      type = types.bool;
      default = false;
    };
  };

  config = mkIf (cfg.enable) { 
    services.adguardhome = {
      enable = true;
    };
  };

}
