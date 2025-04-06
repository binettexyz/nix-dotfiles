{ lib, ... }:
with lib;
{

  options.device = {
    hasBattery = mkOption {
      description = "Device has battery";
      default = false;
    };
    storage = {
      ssd = mkOption {
        description = "If ssd is installed";
        type = types.bool;
        default = false;
      };
      hdd = mkOption {
        description = "If hdd is installed";
        type = types.bool;
        default = true;
      };
    };
  };

}
