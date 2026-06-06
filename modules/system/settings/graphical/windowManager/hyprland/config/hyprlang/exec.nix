{
  flake.modules.homeManager.hyprExec =
    { config, ... }:
    {
      wayland.windowManager.hyprland.settings = {
        exec-once = config.modules.hm.hyprland.exec-once;
      };
    };
}
