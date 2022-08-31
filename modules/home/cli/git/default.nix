{ pkgs, config, lib, ... }:
with lib;

let
  cfg = config.modules.cli.git;
in
{
  options.modules.cli.git = {
    enable = mkOption {
      description = "Enable Git package";
      type = types.bool;
      default = true;
    };
  };

  config = mkIf (cfg.enable) {
    programs.git = {
      enable = true;
      userName = "binettexyz";
      userEmail = "46168797+binettexyz@users.noreply.github.com";
      aliases = {
      };
    };
  };
}
