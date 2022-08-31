{ pkgs, config, lib, ... }:
with lib;

let
  cfg = config.modules.programs.dmenu;
in
{
  options.modules.programs.dmenu = {
    enable = mkOption {
      description = "Enable dmenu file picker";
      type = types.bool;
      default = false;
    };
  };

  config = mkIf (cfg.enable) {
    home.packages = with pkgs; [ dmenu ];
};

}
