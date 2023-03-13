{ config, pkgs, lib, inputs, nix-colors, ... }:
let

  wallpaper = builtins.fetchurl {
    url = "https://w.wallhaven.cc/full/28/wallhaven-28v3mm.jpg";
    sha256 = "1ikipzd4qq985kidgpmrrd21y9c3bh6dlx6y7c4vvlfki73d3azw";
  };

in {

  imports = [
    ../../home-manager/desktop.nix
    (inputs.impermanence + "/home-manager.nix")
    nix-colors.homeManagerModule
    ../../home-manager/helix.nix
  ];

  colorScheme = import ../../modules/colorSchemes/catppuccin.nix;

  home.file.".config/x11/xinitrc".text = ''
    #!/bin/sh
    # vim: ft=sh

      ### screen ###
    xrandr --output DP-2 --gamma 1 # --set "Broadcast RGB" "Full"

      ### app ###
    pidof -s dunst || setsid -f dunst &	    # dunst for notifications

    desktop-bar.sh &    # dwm status bar
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
    hsetroot -fill ${wallpaper} &
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
