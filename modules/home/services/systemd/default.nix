{ pkgs, config, lib, ... }:
with lib;

let
  cfg = config.modules.services.systemd;
in
{
  options.modules.services.systemd= {
    enable = mkOption {
      description = "edit systemd service";
      type = types.bool;
      default = false;
    };
  };

  config = mkIf (cfg.enable) {
    services.journald.extraConfig = ''
      SystemMaxUse=100M
      MaxFileSec=7day
    '';
  };

}
