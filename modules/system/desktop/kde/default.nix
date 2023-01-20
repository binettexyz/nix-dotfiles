{ pkgs, config, lib, inputs, ... }:
with lib;

let
  cfg = config.modules.desktopEnvironment;
in
  {
    options.modules.desktopEnvironment = mkOption {
      description = "Enable KDE";
      type = with types; nullOr (enum [ "kde" ]);
      default = null;
    };

    config = mkIf (cfg == "kde") {
      services.xserver = {
        displayManager = {
          startx.enable = lib.mkForce false;
          sddm.enable = true;
        };
        desktopManager.plasma5 = {
          enable = true;
          excludePackages = with pkgs.libsForQt5; [
          ];
        };
      };
    };

  }
