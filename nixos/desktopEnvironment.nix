{
  config,
  flake,
  lib,
  pkgs,
  ...
}:
with lib;
let
  inherit (flake) inputs;
  inherit (config.meta) username;
  cfg = config.modules.system.desktopEnvironment;
in
{
  # ---Desktop Environment Module---
  options.modules.system.desktopEnvironment = mkOption {
    description = "Enable Desktop Environment";
    type =
      with types;
      nullOr (enum [
        "gamescope"
        "plasma"
        "qtile"
        "hyprland"
      ]);
    default = null;
  };

  # ---Configuration---
  config = mkMerge [
    {

    }
    (mkIf (cfg == "plasma") {
      services.greetd.enable = true;
      services.greetd.settings = rec {
        initial_session = {
          user = username;
          command = "${pkgs.greetd.tuigreet}/bin/tuigreet" + " -t -r" + " --cmd startplasma-wayland";
        };
        default_session = initial_session;
      };
      services.xserver.enable = true;
      services.desktopManager.plasma6.enable = true;
      environment.plasma6.excludePackages = with pkgs.libsForQt5; [
        elisa
        khelpcenter
        oxygen
        discover
        ark
      ];

      environment.systemPackages = with pkgs; [ kdePackages.ark ];
    })

    (mkIf (cfg == "qtile") {
      services.xserver.windowManager.qtile.enable = true;

      services.greetd.enable = true;
      services.greetd.settings = rec {
        initial_session = {
          user = username;
          command =
            "${pkgs.greetd.tuigreet}/bin/tuigreet"
            + " -t -r"
            + " --cmd '${pkgs.python312Packages.qtile}/bin/qtile start -b wayland'";
        };
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

    (mkIf (cfg == "hyprland") {
      programs.hyprland = {
        enable = true;
        xwayland.enable = true;
        withUWSM = true;
      };

      programs.waybar.enable = true;

      services.greetd.enable = true;
      services.greetd.settings = rec {
        initial_session = {
          user = username;
          command = "${pkgs.greetd.tuigreet}/bin/tuigreet" + " -t -r";
        };
        default_session = initial_session;
      };
    })
  ];
}
