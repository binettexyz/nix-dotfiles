{ inputs, ... }:
{
  flake.nixosModules.desktopEnvironment =
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
      # ---Desktop Environment Module---
      options.modules.desktopEnvironment = lib.mkOption {
        description = "Enable Desktop Environment";
        type = lib.types.nullOr (
          lib.types.enum [
            "gamescope-wayland"
            "plasma"
            "qtile"
            "hyprland"
          ]
        );
        default = null;
      };

      # ---Configuration---
      config = lib.mkMerge [
        {
        }
        (lib.mkIf (cfg == "plasma") {
          services.greetd.enable = true;
          services.greetd.settings =
            let
              initial_session = {
                user = if (lib.elem "console" config.modules.device.tags) then "root" else config.meta.username;
                command =
                  if (lib.elem "console" config.modules.device.tags) then
                    "${pkgs.jovian-greeter}/bin/jovian-greeter ${config.meta.username}"
                  else
                    "${pkgs.tuigreet}/bin/tuigreet" + " -t -r" + " --cmd startplasma-wayland";
              };
            in
            {
              initial_session = initial_session;
              default_session = initial_session;
            };
          services.xserver.enable = true;
          services.desktopManager.plasma6.enable = true;
          environment.plasma6.excludePackages = [
            pkgs.kdePackages.elisa
            pkgs.kdePackages.khelpcenter
            pkgs.kdePackages.oxygen
            pkgs.kdePackages.discover
            #pkgs.kdePackages.ark
          ];

          environment.systemPackages = [ pkgs.kdePackages.ark ];
        })

        (lib.mkIf (cfg == "qtile") {
          services.xserver.windowManager.qtile.enable = true;

          services.greetd.enable = true;
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
            {
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
        })

        (lib.mkIf (cfg == "hyprland") {
          programs.hyprland = {
            enable = true;
            #package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
            xwayland.enable = true;
            withUWSM = true;
          };

          services.greetd.enable = true;
          services.greetd.settings =
            let
              initial_session = {
                user = config.meta.username;
                command = "${pkgs.tuigreet}/bin/tuigreet" + " -t -r";
              };
            in
            {
              initial_session = initial_session;
              default_session = initial_session;
            };
        })
      ];
    };
}
