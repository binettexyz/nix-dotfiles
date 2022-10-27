{ inputs, config, pkgs, lib, ... }:
with lib;

let
  cfg = config.modules.profiles.gaming.games.osu;
in
{

  options.modules.profiles.gaming.games.osu.enable = mkEnableOption "osu";

  config = lib.mkIf (cfg.enable) {
    environment.systemPackages = with pkgs; [
      inputs.nix-gaming.packages.${pkgs.system}.osu-stable
    ];
  };
}
