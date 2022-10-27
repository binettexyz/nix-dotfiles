{ inputs, pkgs, config, lib, ... }:
with lib;

let
  cfg = config.modules.programs.discord;
in
{
  options.modules.programs.discord.enable = mkEnableOption "discord";

  config = mkIf (cfg.enable) {
    home.packages = with pkgs; [
      discord-canary-openasar
    ];
  };
}
