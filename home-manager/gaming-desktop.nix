{ config, pkgs, ... }:

{
  imports = [ ./modules ];

  device.type = "gaming-desktop";
  modules.hm = {
    gaming.enable = true;
    browser = { librewolf.enable = true; };
    mpv = {
      enable = true;
      lowSpec = false;
    };
  };

  home.packages = with pkgs; [
    discord
    libreoffice
  ];

}
