{lib, ...}:
with lib; {
  options.meta = {
    username = mkOption {
      description = "Main username";
      type = types.str;
      default = "binette";
    };
    configPath = mkOption {
      description = "Location of this config";
      type = types.path;
      default = "/etc/nixos";
    };
  };
}
