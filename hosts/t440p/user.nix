{ config, pkgs, lib, inputs, ... }:

{
  imports = [
    ../../modules/home/default.nix 
    (inputs.impermanence + "/home-manager.nix")
  ];

  modules = {
    packages = {
      enable = true;
      gaming.enable = false;
    };

    cli = {
      git.enable = true;
      neovim.enable = true;
      tmux.enable = true;
      xdg.enable = true;
      xresources = "gruvbox";
      zsh.enable = true;
    };

    programs = {
      chromium.enable = true;
#      discocss.enable = true;
      dmenu.enable = true;
      librewolf.enable = true;
      lf.enable = true;
      mpv.enable = true;
#      mutt.enable = true;
#      newsboat.enable = true;
#      nnn.enable = true;
      powercord.enable = false;
      qutebrowser.enable = true;
      slstatus = "laptop";
      st.enable = true;
#      zathura.enable = true;
    };

    services = {
      dunst.enable = true;
      flameshot.enable = false;
      picom.enable = true;
      sxhkd.enable = true;
#      udiskie.enable = true;
    };
  };

  home.packages = with pkgs; [ zoom-us ];

  home.file.".config/x11/xinitrc".text = ''
    #!/bin/sh

      ### screen ###
    xrandr --output eDP1 --gamma 1 --set "Broadcast RGB" "Full"

      ### app ###
    pidof -s dunst || setsid -f dunst &	    # dunst for notifications
    slstatus &				    # suckless status bar
    udiskie &				    # automount device daemon
    sxhkd &
    flameshot &
    greenclip daemon &
    transmission-daemon &
    redshift -l 45.35:-73.30 -t 6500:3800 &   # blue filter

      ### Settings ###
    xrandr --dpi 96
    xsetroot -cursor_name left_ptr &	    # change cursor name
    remaps &				    # remaps capslock with esc
    unclutter &				    # remove mouse when idle

      ### Visual ###
    picom --experimental-backend &
    hsetroot -fill /etc/nixos/.github/assets/wallpaper.png &
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
        ".cache/Jellyfin Media Player"
        ".cache/librewolf"
        ".cache/qutebrowser"
  
        ".config/BraveSoftware"
        ".config/jellyfin.org"
        ".config/shell"
  
        ".local/bin"
        ".local/share/applications"
        ".local/share/cargo"
        ".local/share/gnupg"
        ".local/share/jellyfinmediaplayer"
        ".local/share/Jellyfin Media Player"
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
        ".config/zoomus.conf"
        ".local/share/history"
        ".cache/greenclip.history"
      ];
    };
  };

}
