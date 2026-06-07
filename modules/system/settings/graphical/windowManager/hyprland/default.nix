{ inputs, ... }:
{
  flake.nixosModules.hyprland =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      cfg = config.modules.desktopEnvironment;
    in
    {
      config = lib.mkIf (cfg == "hyprland-uwsm") {
        programs.hyprland = {
          enable = true;
          xwayland.enable = true;
          withUWSM = true;
        };
      };
    };

  flake.modules.homeManager.hyprland =
    { config, ... }:
    {
      imports = with inputs.self.modules.homeManager; [
        hyprDefault
        hyprOptions
        hyprpaper
        hypridle
        hyprlock
        swaync
        waybar
        waybarStyle
      ];

      config = {
        wayland.windowManager.hyprland = {
          enable = true;
          package = null;
          portalPackage = null;
          configType = "hyprlang";
          settings = {
            ecosystem = {
              no_update_news = true;
              no_donation_nag = true;
            };
            env = [
              "QT_QPA_PLATFORM,wayland"
              "SDL_VIDEODRIVER,wayland"
              "CLUTTER_BACKEND,wayland"
              "GDK_BACKEND,wayland"
              "MOZ_ENABLE_WAYLAND,1"
              "MOZ_WEBRENDER,1"
              "OZONE_PLATFORM,wayland"
              "NIXOS_OZONE_WL,1"
              "HYPRCURSOR_THEME,${config.gtk.cursorTheme.name}"
              "HYPRCURSOR_SIZE,${toString config.gtk.cursorTheme.size}"
              "XCURSOR_THEME,${config.gtk.cursorTheme.name}"
              "XCURSOR_SIZE,${toString config.gtk.cursorTheme.size}"
            ];
          };
        };
      };
    };

}
