{
  flake.nixosModules.qtile =
    {
      config,
      lib,
      ...
    }:
    let
      cfg = config.modules.desktopEnvironment;
    in
    {
      config = lib.mkIf (cfg == "qtile") {
        services.xserver.windowManager.qtile.enable = true;

        services = {
          irqbalance.enable = true;
          dbus.implementation = "broker";
        };

        # Needed for Flatpak and for discord screenshare.
        xdg.portal = {
          enable = true;
          wlr.enable = true;
          config.common.default = "xdg-desktop-portal-wlr";
        };

      };
    };
  flake.modules.homeManager.qtile = {
    home.file.".config/qtile/config.py".source = ./config/config.py;
    home.file.".config/qtile/autostart.sh" = {
      source = ./config/autostart.sh;
      executable = true;
    };
  };
}
