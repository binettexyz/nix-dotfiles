{ config, pkgs, ... }:

  {

      # enable flatpack
    services.flatpak.enable = true;
    xdg.portal = {
      enable = true;
      extraPortals = with pkgs; [ xdg-desktop-portal-gtk ];
    };

      # enable steam (doesn't work)
    programs.steam.enable = true;
    hardware.steam-hardware.enable = true;

  }
