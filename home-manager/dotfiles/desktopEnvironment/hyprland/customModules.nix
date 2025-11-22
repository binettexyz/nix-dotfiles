{ lib, ... }:
{
  options.modules.hm.hyprland = {
    exec-once = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ "waybar &" ];
      description = "List of command to launch at startup";
    };
    monitor = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      description = "Screens resolution";
    };
    general = {
      sensitivity = lib.mkOption {
        type = lib.types.int;
        default = 0;
        description = "Hyprland mouse sensitivity";
      };
      accel_profile = lib.mkOption {
        type = lib.types.str;
        default = "flat";
        description = "Acceleration profile";
      };
    };
  };
}
