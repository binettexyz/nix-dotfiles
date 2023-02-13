{ config, pkgs, lib, inputs, ... }: {

  imports = [
    ../../home-manager/default.nix 
    (inputs.impermanence + "/home-manager.nix")
  ];

  modules = {
    packages = {
      enable = true;
      gaming.enable = true;
    };

    cli = {
      git.enable = true;
      neovim.enable = true;
      tmux.enable = true;
      xdg.enable = true;
      xresources = {
        enable = true;
        theme = "gruvbox";
      };
      zsh.enable = true;
    };

    programs = {
#     chromium.enable = true;
     discord.enable = true;
     dmenu.enable = true;
     gtk.enable = false;
     lf.enable = true;
     librewolf.enable = true;
     mpv = {
       enable = true;
       desktopConfig.enable = true;
     };
#     mutt.enable = true;
     newsboat.enable = true;
#     nnn.enable = true;
     qutebrowser.enable = true;
     slstatus = "desktop";
     terminal = "st";
#     zathura.enable = true;
    };

    services = {
      dunst.enable = true;
      flameshot.enable = true;
      picom.enable = false;
      sxhkd.enable = true;
#      udiskie.enable = true;
    };
  };

  home.packages = with pkgs; [ mcrcon tidal-hifi ];

  home.file.".config/x11/xinitrc".text = ''
    #!/bin/sh
    # vim: ft=sh

      ### screen ###
    xrandr --output DP-2 --gamma 1 # --set "Broadcast RGB" "Full"

      ### app ###
    pidof -s dunst || setsid -f dunst &	    # dunst for notifications
    slstatus &				    # suckless status bar
    udiskie &				    # automount device daemon
    sxhkd &
    flameshot &
    greenclip daemon &
    nvidia-settings --config=~/.config/.nvidia-settings-rc --load-config-only

      ### Settings ###
#    xrandr --dpi 96
    xsetroot -cursor_name left_ptr &	    # change cursor name
    remaps &				    # remaps capslock with esc
    unclutter &				    # remove mouse when idle
    xbanish &             # remove mouse when using keyboard

      ### Visual ###
#    picom --experimental-backends &
    hsetroot & # -fill /etc/nixos/.github/assets/wallpaper.png &
    xrdb $HOME/.config/x11/xresources & xrdbpid=$!

    [ -n "$xrdbpid" ] && wait "$xrdbpid"

    ssh-agent dwm
  '';

  home.persistence."/nix/persist/home/binette" = {
    removePrefixDirectory = false;
    allowOther = true;
    directories = [
#      ".cache/BraveSoftware"
      ".cache/Jellyfin Media Player"
      ".cache/lutris"
      ".cache/librewolf"
      ".cache/qutebrowser"
      
#      ".config/BraveSoftware"
      ".config/jellyfin.org"
      ".config/lutris"
      ".config/retroarch"
      ".config/shell"
      ".config/tremc"
#      ".config/discordcanary"
      ".config/discord"
#      ".config/powercord"
      ".config/sops"
      ".config/tidal-hifi"
      
      ".local/bin"
      ".local/share/applications"
      ".local/share/cargo"
      ".local/share/games"
      ".local/share/gnupg"
      ".local/share/jellyfinmediaplayer"
      ".local/share/Jellyfin Media Player"
      ".local/share/lutris"
      ".local/share/minecraft"
      ".local/share/password-store"
      ".local/share/PrismLauncher"
      ".local/share/Steam"
      ".local/share/xorg"
      ".local/share/zoxide"
      ".local/share/qutebrowser"

      ".git"
      ".librewolf"
      ".ssh"
      ".steam"
      ".gnupg"
      ".zplug"

      "documents"
      "pictures"
      "videos"
      "downloads"
    ];

    files = [
      ".config/.nvidia-settings-rc"
      ".config/pulse/daemon.conf"
      ".config/greenclip.toml"

      ".local/share/history"

      ".cache/greenclip.history"
    ];
  };

}
