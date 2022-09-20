{ pkgs, config, lib, ... }:
with lib;

let
  cfg = config.modules.services.adGuardHome;
in
{
  options.modules.services.adGuardHome = {
    enable = mkOption {
      description = "Enable AdGuardHome service";
      type = types.bool;
      default = false;
    };
  };

  config = mkIf (cfg.enable) { 

    services.adguardhome = {
      enable = true;
      host = "127.0.0.1";
      port = 3000;
#      settings = {
#      };
    };
  };
}
