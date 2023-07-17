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
      services.xserver.desktopManager.plasma5.enable = true;
      services.xserver.displayManager = {
        sx.enable = lib.mkForce false;
        sddm.enable = true;
        defaultSession = "plasmawayland";
      };
      environment.plasma5.excludePackages = with pkgs.libsForQt5; [
        elisa
        khelpcenter
        oxygen
      ];
    };

  }
