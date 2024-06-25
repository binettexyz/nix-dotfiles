{ config, flake, lib, pkgs, ... }:
with lib;
let
  inherit (flake) inputs;
  cfg = config.modules.desktopEnvironment;
in
  {
    options.modules.desktopEnvironment = mkOption {
      description = "Enable KDE";
      type = with types; nullOr (enum [ "kde" ]);
      default = null;
    };

    config = mkIf (cfg == "kde") {
      services.xserver.desktopManager.plasma6.enable = true;
      services.xserver.displayManager = {
        sx.enable = lib.mkForce false;
        defaultSession = "plasma";
      };
      services.displayManager.sddm.enable = true;
      environment.plasma6.excludePackages = with pkgs.libsForQt5; [
        elisa
        khelpcenter
        oxygen
      ];
    };

  }
