{
  config,
  flake,
  lib,
  ...
}:
{
  options.modules.hm.theme.wallpaper = lib.mkOption {
    type = lib.types.str;
    default = "003";
    description = "Wallpaper filename without extension.";
  };

  config = {
    services.hyprpaper = {
      enable = config.wayland.windowManager.hyprland.enable;
      settings =
        let
          getWallpaper =
            {
              colorScheme,
              name,
            }:
            "~/pictures/wallpapers/${colorScheme}/${name}.png";
          selectedWallpaper = getWallpaper {
            colorScheme = config.modules.hm.theme.colorScheme;
            name = config.modules.hm.theme.wallpaper;
          };
        in
        {
          preload = [ "${selectedWallpaper}" ];
          wallpaper = [
            "HDMI-A-1,${selectedWallpaper}"
            "HDMI-A-2,${selectedWallpaper}"
            "eDP-1,${selectedWallpaper}"
          ];
        };
    };
  };
}
