{
  config,
  deviceTags,
  deviceType,
  flake,
  lib,
  pkgs,
  ...
}: let
  inherit (flake) inputs;
  inherit (config.meta) username;
  cfg = config.modules.system.desktopEnvironment;
in {
  # ---Desktop Environment Module---
  options.modules.system.desktopEnvironment = lib.mkOption {
    description = "Enable Desktop Environment";
    type = lib.types.nullOr (lib.types.enum [
      "gamescope-wayland"
      "plasma"
      "qtile"
      "hyprland-uwsm"
    ]);
    default = null;
  };

  # ---Configuration---
  config = lib.mkMerge [
    {
    }
    (lib.mkIf (cfg == "plasma") {
      services.greetd.enable = true;
      services.greetd.settings = let
        initial_session = {
          user =
            if (config.modules.gaming.enable && lib.elem "console" deviceTags)
            then "root"
            else username;
          command =
            if (config.modules.gaming.enable && lib.elem "console" deviceTags)
            then "${pkgs.jovian-greeter}/bin/jovian-greeter ${username}"
            else "${pkgs.tuigreet}/bin/tuigreet" + " -t -r" + " --cmd startplasma-wayland";
        };
      in {
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

      environment.systemPackages = [pkgs.kdePackages.ark];
    })

    (lib.mkIf (cfg == "qtile") {
      services.xserver.windowManager.qtile.enable = true;

      services.greetd.enable = true;
      services.greetd.settings = let
        initial_session = {
          user = username;
          command =
            "${pkgs.tuigreet}/bin/tuigreet"
            + " -t -r"
            + " --cmd '${pkgs.python312Packages.qtile}/bin/qtile start -b wayland'";
        };
      in {
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

    (lib.mkIf (cfg == "hyprland-uwsm") {
      programs.hyprland = {
        enable = true;
        xwayland.enable = true;
        withUWSM = true;
      };

      services.greetd.enable = true;
      services.greetd.settings = let
        initial_session = {
          user = username;
          command = "${pkgs.tuigreet}/bin/tuigreet" + " -t -r";
        };
      in {
        initial_session = initial_session;
        default_session = initial_session;
      };
    })
  ];
}
