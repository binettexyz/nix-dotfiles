{
  flake.modules.homeManager.hyprGeneral =
    { config, ... }:
    {
      wayland.windowManager.hyprland.settings.general = {
        general = {
          allow_tearing = false;
          border_size = 2;
          "col.active_border" = "rgba(${config.colorScheme.palette.activeBorder}aa)";
          "col.inactive_border" = "rgba(${config.colorScheme.palette.inactiveBorder}aa)";
          gaps_in = 8;
          gaps_out = 8;
          #no_border_on_floating = false;
          resize_on_border = false;
        };

      };
    };
}
