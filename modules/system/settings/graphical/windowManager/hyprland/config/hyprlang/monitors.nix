{
  flake.modules.homeManager.hyprMonitors =
    { config, ... }:
    {
      wayland.windowManager.hyprland.settings.monitor = config.modules.hm.hyprland.monitor;

    };
}
