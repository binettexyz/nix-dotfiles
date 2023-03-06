{ config, pkgs, lib, inputs, nix-colors, ... }: {

  imports = [
    ../../home-manager/desktop.nix
    (inputs.impermanence + "/home-manager.nix")
    nix-colors.homeManagerModule
  ];

  #TODO: catppuccin colorscheme with pitch black background
  colorScheme = {
    slug = "Gruvbox-Material";
    name = "Gruvbox-Material";
    author = "https://github.com/sainnhe/gruvbox-material";
    colors = {
      base00 = "#000000";
      base01 = "#ea6962";
      base02 = "#a9b665";
      base03 = "#e78a4e";
      base04 = "#7daea3";
      base05 = "#d3869b";
      base06 = "#89b482";
      base07 = "#d4be98";
      base08 = "#000000";
      base09 = "#ea6962";
      base0A = "#a9b665";
      base0B = "#e78a4e";
      base0C = "#7daea3";
      base0D = "#d3869b";
      base0E = "#89b482";
      base0F = "#d4be98";
    };
  };

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
