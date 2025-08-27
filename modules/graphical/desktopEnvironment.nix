{
  config,
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
            if config.jovian.steam.enable
            then "root"
            else username;
          command =
            if config.jovian.steam.enable
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
        pkgs.libsForQt5.elisa
        pkgs.libsForQt5.khelpcenter
        pkgs.libsForQt5.oxygen
        pkgs.libsForQt5.discover
        pkgs.libsForQt5.ark
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
          user =
            if config.jovian.steam.enable
            then "root"
            else username;
          command =
            if config.jovian.steam.enable
            then "${pkgs.jovian-greeter}/bin/jovian-greeter ${username}"
            else "${pkgs.tuigreet}/bin/tuigreet" + " -t -r";
        };
      in {
        initial_session = initial_session;
        default_session = initial_session;
      };
    })
  ];
}
