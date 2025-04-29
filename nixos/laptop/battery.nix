{
  config,
  lib,
  pkgs,
  deviceRole,
  ...
}: let
  cfg = config.laptop.onLowBattery;
in {
  options.laptop.onLowBattery = {
    enable = lib.mkEnableOption "Perform action on low battery";
    thresholdPercentage = lib.mkOption {
      description = "Threshold battery percentage on which to perform the action";
      default = 8;
      type = lib.types.int;
    };
    action = lib.mkOption {
      description = "Action to perform on low battery";
      default = "hibernate";
      type = lib.types.enum [
        "hibernate"
        "suspend"
        "suspend-then-hibernate"
      ];
    };
  };

  config = lib.mkIf (deviceRole == "laptop") {
    services.udev = lib.mkIf cfg.enable {
      extraRules = lib.concatStrings [
        ''SUBSYSTEM=="power_supply", ''
        ''ATTR{status}=="Discharging", ''
        ''ATTR{capacity}=="[0-${toString cfg.thresholdPercentage}]", ''
        ''RUN+="${pkgs.systemd}/bin/systemctl ${cfg.action}"''
      ];
    };
  };
}
