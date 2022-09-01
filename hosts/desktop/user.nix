{ config, pkgs, lib, inputs, ... }:

{
  imports = [
    ../../modules/home/default.nix 
    (inputs.impermanence + "/home-manager.nix")
  ];

  modules = {
    packages = {
      enable = true;
      gaming.enable = true;
    };
#    desktop = {
#      lockscreen.enable = false;
#      xresources.enable = true;

    cli = {
      git.enable = true;
      neovim.enable = true;
      tmux.enable = true;
#     xdg.enable = true;
      zsh.enable = true;
    };

    programs = {
      chromium.enable = true;
#     discocss.enable = true;
     dmenu.enable = true;
     dunst.enable = true;
     librewolf.enable = true;
     lf.enable = true;
     mpv.enable = true;
#     mutt.enable = true;
#     newsboat.enable = true;
#     nnn.enable = true;
#     powercord.enable = true;
     qutebrowser.enable = true;
     slstatus.enable = true;
     st.enable = true;
#     zathura.enable = true;
    };

    services = {
      picom.enable = true;
#      redshift.enable = true;
#      sxhkd.enable = true;
#      udiskie.enable = true;
    };
  };

  home.packages = with pkgs; [ virt-manager tidal-hifi flameshot ];

  home.file.".config/x11/xprofile".text = ''
    #!/bin/sh

      ### screen ###
    xrandr --output DP-2 --gamma 0.8 # --set "Broadcast RGB" "Full"

      ### app ###
    pidof -s dunst || setsid -f dunst &	    # dunst for notifications
    slstatus &				    # suckless status bar
    udiskie &				    # automount device daemon
    greenclip daemon &
#    transmission-daemon &

      ### Settings ###
    xrandr --dpi 96
    xsetroot -cursor_name left_ptr &	    # change cursor name
    remaps &				    # remaps capslock with esc
    unclutter &				    # remove mouse when idle

      ### Visual ###
    picom --experimental-backends &
    hsetroot -fill $HOME/.config/wall.png &
    xrdb $HOME/.config/x11/xresources & xrdbpid=$!

    [ -n "$xrdbpid" ] && wait "$xrdbpid"
  '';

  home.persistence."/nix/persist/home/binette" = {
    removePrefixDirectory = false;
    allowOther = true;
    directories = [
      ".config/discordcanary"
      ".config/powercord"
      ".config/tidal-hifi"
      ".steam"
    ];

    files = [
      ".nvidia-settings-rc"
    ];
  };

}
