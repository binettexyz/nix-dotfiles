{ config, pkgs, lib, inputs, nix-colors, ... }: {

  imports = [
    ../../home-manager/desktop.nix
    (inputs.impermanence + "/home-manager.nix")
    nix-colors.homeManagerModule
  ];

  colorScheme = import ../../modules/colorSchemes/gruvbox-material.nix;

  home.file.".config/x11/xinitrc".text = ''
    #!/bin/sh
    # vim: ft=sh

      ### screen ###
    xrandr --output DP-2 --gamma 1 # --set "Broadcast RGB" "Full"

      ### app ###
    pidof -s dunst || setsid -f dunst &	    # dunst for notifications
    udiskie &				    # automount device daemon
    flameshot &
    greenclip daemon &
    nvidia-settings --config=~/.config/.nvidia-settings-rc --load-config-only

      ### Settings ###
#    xrandr --dpi 96
    wpctl set-volume -l 1.0 @DEFAULT_AUDIO_SINK@ 100%+
    xsetroot -cursor_name left_ptr &	    # change cursor name
    remaps &				    # remaps capslock with esc

      ### Visual ###
    desktop-bar &       # dwm status bar
    picom --experimental-backends &
    hsetroot -fill ${pkgs.wallpapers.gruvbox} &
    xrdb $HOME/.config/x11/xresources & xrdbpid=$!

    [ -n "$xrdbpid" ] && wait "$xrdbpid"

    ssh-agent dwm
  '';

  home.persistence."/nix/persist/home/binette" = {
    removePrefixDirectory = false;
    allowOther = true;
    directories = [
#      ".cache/BraveSoftware"
#      ".cache/Jellyfin Media Player"
      ".cache/lutris"
      ".cache/librewolf"
      ".cache/qutebrowser"
      
#      ".config/BraveSoftware"
#      ".config/jellyfin.org"
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
#      ".local/share/jellyfinmediaplayer"
#      ".local/share/Jellyfin Media Player"
      ".local/share/lutris"
      ".local/share/nvim"
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
