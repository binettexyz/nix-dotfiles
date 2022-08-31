{ pkgs, config, lib, ... }:
with lib;

let
  cfg = config.modules.services.picom;
in
{
  options.modules.services.picom = {
    enable = mkOption {
      description = "Enable picom service";
      type = types.bool;
      default = false;
    };
  };

  config = mkIf (cfg.enable) {
    services.picom = {
      enable = lib.mkDefault true;
      backend = lib.mkDefault "glx";
      experimentalBackends = true;
      fade = lib.mkDefault false;
      fadeDelta = lib.mkDefault 5;
  #    activeOpacity = 0.9;
  #    opacityRules = [ "100:class_g = 'spfm'" ];
  #    inactiveOpacity = 0.7;
      shadow = lib.mkDefault false;
      vSync = true;
    };
  };
}
