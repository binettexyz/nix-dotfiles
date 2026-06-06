{
  flake.modules.homeManager.hyprMisc = {
    wayland.windowManager.hyprland.settings.misc = {
      # Set to 0 or 1 to disable the anime mascot wallpapers
      force_default_wallpaper = 0;
      # If true disables the random hyprland logo / anime girl background.
      disable_hyprland_logo = true;
    };
  };
}
