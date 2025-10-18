{config, ...}: {
  programs.hyprlock = {
    enable = config.wayland.windowManager.hyprland.enable;
  };
}
