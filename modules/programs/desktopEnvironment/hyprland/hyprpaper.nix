{
  flake.modules.homeManager.hyprpaper =
    { config, ... }:
    {
      config = {
        services.hyprpaper = {
          enable = true;
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
              wallpaper = [
                {
                  monitor = "";
                  path = "${selectedWallpaper}";
                  fit_mode = "cover";
                }
              ];
            };
        };
      };
    };
}
