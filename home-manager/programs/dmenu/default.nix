{ pkgs, config, lib, inputs, ... }:
with lib;

let
  cfg = config.modules.programs.dmenu;
  dmenu-head = pkgs.callPackage (inputs.dmenu + "/default.nix") {};
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
    home.packages = with pkgs; [ dmenu-head ];
};

}
