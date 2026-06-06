{
  flake.modules.homeManager.hyprAnimations =
    { config, lib, ... }:
    {
      wayland.windowManager.hyprland.settings.animations = {
        enabled = if lib.elem "lowSpec" config.modules.device.tags then false else true;
        bezier = [
          "smoothIn, 0.25, 1, 0.5, 1"
          "pace, 0.46, 1, 0.29, 0.99"
          "smoothOut, 0.36, 0, 0.66, -0.56"
          "overshot, 0.05, 0.9, 0.1, 1.05"
        ];
        animation = [
          "fade, 1, 3, smoothIn"
          "windowsIn, 1, 3, smoothIn"
          "windowsOut, 1, 3, smoothOut"
          "windowsMove, 1, 3, pace, slide"
          "workspaces, 1, 2, default"
          "layers, 1, 2, pace, slide"
          "specialWorkspace, 1, 3, pace, slidevert"
        ];
      };
    };
}
