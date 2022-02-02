{ config, pkgs, lib, ... }:

{

    environment = {
      systemPackages = with pkgs; [

          # system
        xdotool
        maim
        slop
        xclip
        hsetroot
        udiskie
        unclutter-xfixes
        dunst
        libnotify
        seturgent
        neovim
        twmn
        redshift
          # media
        mpv
        sxiv
        playerctl
          # text
        zathura
      ];
    };
}
