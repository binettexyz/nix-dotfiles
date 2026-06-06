{
  flake.modules.homeManager.hyprTheme =
    { config, lib, ... }:
    {
      wayland.windowManager.hyprland.settings = {
        decoration = {
          rounding = 10;
          rounding_power = 2;
          active_opacity = 1.0;
          inactive_opacity = 1.0;
          blur = {
            enabled = true;
            size = 3;
            passes = 1;
            vibrancy = 0.1696;
          };
          shadow = {
            enabled = if lib.elem "lowSpec" config.modules.device.tags then false else true;
          };
        };

        #FIXME
        /*
          layerrule = [
                     "noanim,selection"
                   ];
        */
      };
    };
}
