{ pkgs, config, lib, ... }:
with lib;

let
  cfg = config.modules.programs.st;
in
{
  options.modules.programs.st = {
    enable = mkOption {
      description = "Enable st terminal";
      type = types.bool;
      default = false;
    };
  };

  config = mkIf (cfg.enable) {
    home.packages = with pkgs; [ st ];
};

}
