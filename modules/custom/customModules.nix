{lib, ...}: {
  options = {
    meta = {
      username = lib.mkOption {
        description = "Main username";
        type = lib.types.str;
        default = "binette";
      };
      configPath = lib.mkOption {
        description = "Location of this config";
        type = lib.types.path;
        default = "/etc/nixos";
      };
    };
    modules.gaming = {
      enable = lib.mkOption {
        description = "Gaming config";
        default = false;
      };
      device.isSteamdeck = lib.mkOption {
        description = "iF device is a steamdeck";
        default = false;
      };
    };
  };
}
