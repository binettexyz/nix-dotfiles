{ pkgs, config, lib, ... }:
with lib;

let
  cfg = config.modules.cli.tmux;
in
{
  options.modules.cli.tmux= {
    enable = mkOption {
      description = "Enable tmux package";
      type = types.bool;
      default = true;
    };
  };

  config = mkIf (cfg.enable) {  
    programs.tmux = {
      enable = true;
      shortcut = "a";
      keyMode = "vi";
      baseIndex = 1;
      clock24 = true;
      terminal = "screen-256color";
    };
  };
}
