{ lib, ... }:
{
  flake.nixosModules.dmOptions = {
    # ---Desktop Environment Module---
    options.modules.desktopEnvironment = lib.mkOption {
      description = "Enable Desktop Environment";
      type = lib.types.nullOr (
        lib.types.enum [
          "gamescope-wayland"
          "plasma"
          "qtile"
          "hyprland-uwsm"
        ]
      );
      default = null;
    };
  };
}
