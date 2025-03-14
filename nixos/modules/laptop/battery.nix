{ config, lib, pkgs, ... }:
with lib;

let
  cfg = config.laptop.onLowBattery;
in {

  options.laptop.onLowBattery = {
    enable = mkEnableOption "Perform action on low battery";
    thresholdPercentage = mkOption {
      description = "Threshold battery percentage on which to perform the action";
      default = 8;
      type = types.int;
    };
    action = mkOption {
      description = "Action to perform on low battery";
      default = "hibernate";
      type = types.enum [ "hibernate" "suspend" "suspend-then-hibernate" ];
    };
  };

  config = lib.mkIf (config.device.type == "laptop") {
    services.udev = lib.mkIf cfg.enable {
      extraRules = concatStrings [
        ''SUBSYSTEM=="power_supply", ''
        ''ATTR{status}=="Discharging", ''
        ''ATTR{capacity}=="[0-${toString cfg.thresholdPercentage}]", ''
        ''RUN+="${pkgs.systemd}/bin/systemctl ${cfg.action}"''
      ];
    };
  };

}
