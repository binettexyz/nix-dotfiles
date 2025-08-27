{lib, ...}: {
  options.device = {
    hasBattery = lib.mkOption {
      description = "Device has battery";
      default = false;
    };
    videoOutput = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      description = "Video output for each screens";
      default = null;
    };
    storage = {
      ssd = lib.mkOption {
        description = "If ssd is installed";
        type = lib.types.bool;
        default = false;
      };
      hdd = lib.mkOption {
        description = "If hdd is installed";
        type = lib.types.bool;
        default = true;
      };
    };
  };
}
