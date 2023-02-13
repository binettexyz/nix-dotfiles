{ inputs, pkgs, config, lib, ... }:
with lib;

let
  cfg = config.modules.profiles.gaming;
in
{

  imports = [
    ./minecraft-server
    ./lutris/default.nix
    ./steam/default.nix
    ./legendary/default.nix
    ./osu
    ];

  options.modules.profiles.gaming = {
    enable = mkEnableOption "gaming";
  };

    config = mkIf (cfg.enable) {

      modules = {
        containers.mcServer.enable = true;
        profiles.gaming = {
          mcServer.enable = true;
          launchers = {
#            legendary.enable = true;
#            lutris.enable = true;
            steam.enable = true;
          };
          games = {
#            osu.enable = true; # take too much time to compile and crash
          };
        };
      };

      hardware.xpadneo.enable = true;

      programs.gamemode = {
        enable = true;
        enableRenice = true;
        settings = {
          general = {
            softrealtime = "auto";
            renice = 10;
          };
          custom = {
            start = "${pkgs.libnotify}/bin/notify-send 'Gamemode started'";
            end = "${pkgs.libnotify}/bin/notify-send 'Gamemode ended'";
          };
        };
      };

      nix.settings = {
        substituters = [ "https://nix-gaming.cachix.org" ];
        trusted-public-keys = [ "nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4=" ];
      };

      environment.systemPackages = with pkgs; [
#        inputs.nix-gaming.packages.${pkgs.system}.wine-tkg
#        winetricks
#        protontricks
#        gamemode
        jdk # minecraft java
      ];
    };

}

