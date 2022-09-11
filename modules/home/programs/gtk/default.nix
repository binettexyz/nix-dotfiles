{ pkgs, config, lib, inputs, ... }:
with lib;

let
  cfg = config.modules.programs.gtk;
in
{
  options.modules.programs.gtk = {
    enable = mkOption {
      description = "Enable gtk config";
      type = types.bool;
      default = false;
    };
  };

  config = mkIf (cfg.enable) {
    gtk = {
      enable = true;
      theme = {
        package = pkgs.gruvbox-material-gtk;
        name = "Gruvbox-Material-Dark";
      };
    };
    home.packages = with pkgs; [ gtk-engine-murrine ];
  };

}

