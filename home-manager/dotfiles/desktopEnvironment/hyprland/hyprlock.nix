{osConfig, ...}: {
  programs.hyprlock = {
    enable = osConfig.programs.hyprland.enable;
  };
}
