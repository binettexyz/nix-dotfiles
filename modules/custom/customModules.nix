{lib, ...}: {
  options.modules.gaming = {
    enable = lib.mkOption {
      description = "Gaming config";
      default = false;
    };
    device.isSteamdeck = lib.mkOption {
      description = "iF device is a steamdeck";
      default = false;
    };
  };
}
