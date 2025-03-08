{ config, pkgs, ... }:

{
  imports = [ ./modules ];

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
