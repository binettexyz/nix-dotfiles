{ pkgs, config, lib, ... }:
with lib;

let
  cfg = config.modules.cli.xdg;
in
{
  options.modules.cli.xdg = {
    enable = mkOption {
      description = "Set xdg directories";
      type = types.bool;
      default = true;
    };
  };

  config = mkIf (cfg.enable) {
    xdg = {
      userDirs = {
        enable = true;
        createDirectories = false;
    
        documents = "$HOME/documents";
        download = "$HOME/downloads";
        pictures = "$HOME/pictures";
        videos = "$HOME/videos";
      };
    };
  };  
}
