{ pkgs, config, lib, inputs, ... }:
with lib;

let
  cfg = config.modules.programs.kitty;
in
{
  options.modules.programs.kitty = {
    enable = mkOption {
      description = "Enable kitty terminal";
      type = types.bool;
      default = false;
    };
  };

  config = mkIf (cfg.enable) {
    programs.kitty = {
      enable = true;
      environment = {};
      font = {};
      keybindings = {};
        # https://github.com/kovidgoyal/kitty-themes
      theme = "Gruvbox Material Dark Hard";
      settings = {
        font_family = "monospace";
        font_size = 13.0;
        disable_ligatures = "never";
      };
    };
};

}
