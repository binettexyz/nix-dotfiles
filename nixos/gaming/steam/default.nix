{ inputs, config, pkgs, lib, ... }:
with lib;

let
  cfg = config.modules.profiles.gaming.launchers.steam;
in
{

  options.modules.profiles.gaming.launchers.steam.enable = mkEnableOption "Steam";

  config = lib.mkIf (cfg.enable) {
    programs.steam.enable = true;
    hardware.steam-hardware.enable = true;
    environment.systemPackages = with pkgs; [
      steam
        # Enable terminal interaction
      steamPackages.steamcmd
      steam-tui
    ];
  };

}

