{ config, flake, lib, pkgs, ... }:
with lib;
let
  inherit (flake) inputs;
  inherit (config.networking) hostName;
  cfg = config.modules.system.desktopEnvironment;
in
  {
    /* ---Desktop Environment Module--- */
    options.modules.system.desktopEnvironment = mkOption {
      description = "Enable Desktop Environment";
      type = with types; nullOr (enum [ "dwm" "gamescope-wayland" "plasma" "qtile" ]);
      default = null;
    };

    /* ---Configuration--- */
    config = mkMerge [
      {

      }
      (mkIf (cfg == "plasma") {
        services.xserver.displayManager.sx.enable = lib.mkForce false;
        services.xserver.enable = true;
        services.desktopManager.plasma6.enable = true;
        services.displayManager.defaultSession = "plasma";
        services.xserver.displayManager.lightdm.enable = if config.jovian.steam.enable then false else true;
        environment.plasma6.excludePackages = with pkgs.libsForQt5; [
          elisa
          khelpcenter
          oxygen
          discover
          ark
        ];

        environment.systemPackages = with pkgs; [ kdePackages.ark ];
      })

      (mkIf (cfg == "dwm") {
        services.xserver.windowManager.dwm.enable = true;

        services = {
          greenclip.enable = true;
          unclutter-xfixes = {
            enable = true;
            extraOptions = [
              "start-hidden"
            ];
          };
          xbanish.enable = true;
          irqbalance.enable = true;
          dbus.implementation = "broker";
        };

          # Needed for Flatpak.
        xdg.portal.enable = true;
        xdg.portal.extraPortals = [ pkgs.kdePackages.xdg-desktop-portal-kde ];

      })

      (mkIf (cfg == "qtile") {
        services.xserver.windowManager.qtile.enable = true;

        services.greetd = {
          enable = true;
          settings = rec {
            initial_session = {
              user = "binette";
              command = "${pkgs.greetd.tuigreet}/bin/tuigreet"
              + " -t -r"
              + " --cmd '${pkgs.python312Packages.qtile}/bin/qtile start -b wayland'";
            };
            default_session = initial_session;
          };
        };

        services = {
          irqbalance.enable = true;
          dbus.implementation = "broker";
        };

          # Needed for Flatpak.
        xdg.portal.enable = true;
        xdg.portal.extraPortals = [ pkgs.kdePackages.xdg-desktop-portal-kde ];
      })
    ];
  }
