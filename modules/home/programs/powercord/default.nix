{ inputs, pkgs, config, lib, ... }:
with lib;

let
  cfg = config.modules.programs.powercord;
in
{
  options.modules.programs.powercord = {
    enable = mkOption {
      description = "Enable powercord overlay";
      type = types.bool;
      default = false;
    };
  };

  config = mkIf (cfg.enable) {
    home.packages = with pkgs; [
      (discord-plugged.override {
        discord-canary = discord-canary.override {
          nss = pkgs.nss_latest;
#          withOpenASAR = true;
        };

        plugins = [
          inputs.disc-betterReplies
          inputs.disc-doubleClickVC
          inputs.disc-muteNewGuild
          inputs.disc-popoutFix
          inputs.disc-screenshareCrack
          inputs.disc-unindent
          inputs.disc-silentTyping
        ];

        themes = [
          inputs.disc-gruvbox
        ];
      })
    ];
  };
}
