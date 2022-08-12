{ lib, ... }:
{
  services.picom = {
    enable = lib.mkDefault true;
    backend = lib.mkDefault "glx";
    experimentalBackends = true;
    fade = lib.mkDefault true;
    fadeDelta = lib.mkDefault 5;
    activeOpacity = 0.9;
#    opacityRules = [ "100:class_g = 'spfm'" ];
    inactiveOpacity = 0.7;
    shadow = lib.mkDefault false;
    vSync = true;
  };
}
