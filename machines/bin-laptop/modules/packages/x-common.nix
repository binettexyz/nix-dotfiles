{ config, pkgs, lib, ... }:

{
    environment = {
      systemPackages = with pkgs; [

          # system
        xorg.xinit
        xorg.xev
        xorg.xmodmap
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
        polybar
          # media
        mpv
        sxiv
        playerctl
          # text
        zathura
      ];
    };
}
