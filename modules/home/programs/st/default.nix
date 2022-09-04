{ pkgs, config, lib, inputs, ... }:
with lib;

let
  cfg = config.modules.programs.st;
  st-head = pkgs.callPackage (inputs.st + "/default.nix") {};
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
    home.packages = with pkgs; [ st /*st-head*/ ];
};

}
