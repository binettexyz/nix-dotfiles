{ lib, ... }:
{
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
  };
}
