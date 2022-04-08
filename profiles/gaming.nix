{ config, pkgs, ... }:

  {

      # enable flatpack
    services.flatpak.enable = true;
    xdg.portal.enable = true;

      # enable steam
#    programs.steam.enable = true;
#    hardware.steam-hardware.enable = true;

  }
