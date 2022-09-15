{ pkgs, config, lib, ... }:
with lib;

let
  cfg = config.modules.services.greenclip;
in
{
  options.modules.services.greenclip = {
    enable = mkOption {
      description = "Enable greenclip service";
      type = types.bool;
      default = false;
    };
  };

  config = mkIf (cfg.enable) { 
    services.greenclip.enable = true;
    services.gvfs.enable = lib.mkForce false;
  };

  #home.file.".config/mpv/mpv.conf".text = lib.strings.concatStringsSep "\n" [

}
