{ inputs, pkgs, config, lib, ... }:
with lib;

let
  cfg = config.modules.profiles.gaming;
in
{

  imports = [ ../server/containers/minecraft ];

  options.modules.profiles.gaming = {
    enable = mkOption {
      description = "Enable gaming options";
      type = types.bool;
      default = false;
    };
  };

    config = mkIf (cfg.enable) {

      programs.steam.enable = true;
      hardware.steam-hardware.enable = true;

        # enable flatpack
      services.flatpak.enable = true;
      xdg.portal = {
        enable = true;
        extraPortals = with pkgs; [ xdg-desktop-portal-gtk ];
      };

      modules.containers.mcServer.enable = true;

      environment.systemPackages = with pkgs; [ jdk ];
    };

}

