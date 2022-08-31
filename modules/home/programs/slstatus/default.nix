{ pkgs, config, lib, ... }:
with lib;

let
  cfg = config.modules.programs.slstatus;
in
{
  options.modules.programs.slstatus = {
    enable = mkOption {
      description = "Enable slstatus bar";
      type = types.bool;
      default = false;
    };
  };

  config = mkIf (cfg.enable) {
    home.packages = with pkgs; [ slstatus ];
  };


}
