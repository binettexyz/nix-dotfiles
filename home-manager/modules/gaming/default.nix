{ config, pkgs, flake, lib, ... }:
with lib;

let
  cfg = config.modules.hm.gaming;
in {

  imports = [ ./games_config ];

  options.modules.hm.gaming = {
    enable = mkOption {
      description = "Enable Gaming related configuration";
      default = false;
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      # Games
      prismlauncher # Minecraft Launcher
      gzdoom # Modded doom
      #zeroad # Historical real-time strategy game
  
      # Launcher/Tools
      heroic # Launcher for epic/gog/amazon
      protonup-qt # Download proton-ge.
      r2modman # Mods manager
      lutris
      wineWowPackages.waylandFull
      parsec-bin
    ];
  };

}

