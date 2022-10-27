{ inputs, config, pkgs, lib, ... }:
with lib;

let
  cfg = config.modules.profiles.gaming.launchers.legendary;
in {

  options.modules.profiles.gaming.launchers.legendary.enable = mkEnableOption "Legendary";

  config = lib.mkIf (cfg.enable) {
    environment.systemPackages = with pkgs; [
      legendary-gl
      rare # GUI for Legendary (not working)
      wineWowPackages.stable # 32-bit and 64-bit wineWowPackages, see https://nixos.wiki/wiki/Wine
    ];

  };

}
