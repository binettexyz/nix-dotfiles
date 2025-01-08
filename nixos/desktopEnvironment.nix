{ config, flake, lib, pkgs, ... }:
with lib;
let
  inherit (flake) inputs;
  cfg = config.modules.desktopEnvironment;
in
  {
    options.modules.desktopEnvironment = mkOption {
      description = "Enable Desktop Environment";
      type = with types; nullOr (enum [ "kde" "gnome" "gamescope-wayland" ]);
      default = null;
    };

    config = mkMerge [
      (mkIf (cfg == "kde") {
        services.xserver.displayManager.sx.enable = lib.mkForce false;
        services.desktopManager.plasma6.enable = true;
        services.displayManager = {
          sddm.enable = true;
          defaultSession = "plasma";
        };
        environment.plasma6.excludePackages = with pkgs.libsForQt5; [
          elisa
          khelpcenter
          oxygen
        ];
      })
      (mkIf (cfg == "gnome") {
        services.xserver.displayManager.sx.enable = lib.mkForce false;
        services.xserver.desktopManager.gnome.enable = true;
        services.xserver.displayManager = {
          gdm.enable = true;
          defaultSession = "gnome";
        };
        environment.gnome.excludePackages = with pkgs.libsForQt5; [
        ];
      })
    ];
  }
