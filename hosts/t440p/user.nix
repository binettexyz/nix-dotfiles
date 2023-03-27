{ config, pkgs, lib, inputs, ... }:

{
  imports = [
    ../../home-manager/laptop.nix 
    (inputs.impermanence + "/home-manager.nix")
  ];

  home.file.".config/x11/xinitrc".text = ''
    #!/bin/sh

      ### screen ###
    xrandr --output eDP1 --gamma 1 --set "Broadcast RGB" "Full"

      ### app ###
    pidof -s dunst || setsid -f dunst &	    # dunst for notifications
    udiskie &				    # automount device daemon
    flameshot &
    greenclip daemon &
    transmission-daemon &
    redshift -l 45.35:-73.30 -t 6500:3800 &   # blue filter

      ### Settings ###
    #xrandr --dpi 96
    xsetroot -cursor_name left_ptr &	    # change cursor name
    remaps &				    # remaps capslock with esc

      ### Visual ###
    picom --experimental-backend &
    hsetroot -fill $HOME/.config/wall.png &
    xrdb $HOME/.config/x11/xresources & xrdbpid=$!

    [ -n "$xrdbpid" ] && wait "$xrdbpid"

    ssh-agent dwm
  '';

  home.persistence = {
    "/nix/persist/home/binette" = {
      removePrefixDirectory = false;
      allowOther = true;
      directories = [
        ".cache/BraveSoftware"
        #".cache/Jellyfin Media Player"
        ".cache/librewolf"
        ".cache/qutebrowser"
  
        #".config/BraveSoftware"
        #".config/jellyfin.org"
        ".config/shell"
        ".config/sops"
  
        ".local/bin"
        ".local/share/applications"
        ".local/share/cargo"
        ".local/share/gnupg"
        #".local/share/jellyfinmediaplayer"
        #".local/share/Jellyfin Media Player"
        ".local/share/password-store"
        ".local/share/Ripcord"
        ".local/share/xorg"
        ".local/share/zoxide"
        ".local/share/qutebrowser"
  
        ".git"
        ".librewolf"
        ".ssh"
        ".gnupg"
        ".zplug"
  
        "documents"
        "pictures"
        "videos"
        "downloads"
      ];
      files = [
        ".config/greenclip.toml"
        ".config/wall.png"
        #".config/zoomus.conf"
        ".local/share/history"
        ".cache/greenclip.history"
      ];
    };
  };

}
