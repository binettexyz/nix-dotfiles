{
  flake.nixosModules.qtile =
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
      config = lib.mkIf (cfg == "qtile") {
        services.xserver.windowManager.qtile.enable = true;

        services.greetd.enable = lib.mkIf (!(lib.elem "console" config.modules.device.tags)) true;
        services.greetd.settings =
          let
            initial_session = {
              user = config.meta.username;
              command =
                "${pkgs.tuigreet}/bin/tuigreet"
                + " -t -r"
                + " --cmd '${pkgs.python312Packages.qtile}/bin/qtile start -b wayland'";
            };
          in
          lib.mkIf (!(lib.elem "console" config.modules.device.tags)) {
            initial_session = initial_session;
            default_session = initial_session;
          };

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
