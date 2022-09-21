{ inputs, pkgs, config, lib, ... }:
with lib;

let
  cfg = config.modules.profiles.gaming;
in
{
  options.modules.profiles.gaming = {
    enable = mkOption {
      description = "Enable gaming options";
      type = types.bool;
      default = false;
    };
  };

    config = mkIf (cfg.enable) {
      hardware.nvidia.modesetting.enable = true;
      programs.steam.enable = true;
      hardware.steam-hardware.enable = true;

        # enable flatpack
      services.flatpak.enable = true;
      xdg.portal = {
        enable = true;
        extraPortals = with pkgs; [ xdg-desktop-portal-gtk ];
      };

      environment.systemPackages = with pkgs; [ jdk papermc ];
    };

}

