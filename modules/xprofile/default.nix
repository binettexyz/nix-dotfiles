{ config, ... }: {

  home-manager.users.binette.home.file.".config/x11/xprofile".text = ''
    #!/bin/sh

      ### screen ###
    xrandr --output HDMI1 --gamma 0.8 # --set "Broadcast RGB" "Full"

      ### app ###
    pidof -s dunst || setsid -f dunst &	    # dunst for notifications
    slstatus &				    # suckless status bar
    udiskie &				    # automount device daemon
    greenclip daemon &
    transmission-daemon &
    redshift -l 45.35:-73.30 -t 6500:3800 &   # blue filter

      ### Settings ###
    # xrandr --dpi 96
    xsetroot -cursor_name left_ptr &	    # change cursor name
    remaps &				    # remaps capslock with esc
    unclutter &				    # remove mouse when idle

      ### Wallpaper, xresources and compositor ###
    # xcompmgr &
    picom &
    hsetroot -fill $HOME/.config/wall.png &
    xrdb $HOME/.config/x11/xresources & xrdbpid=$!

    [ -n "$xrdbpid" ] && wait "$xrdbpid"
  '';

}
