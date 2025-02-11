{ config, pkgs, flake, ... }:
let
  inherit (flake) inputs;
in {

  imports = [
    ../../home-manager/laptop.nix 
    (inputs.impermanence + "/home-manager.nix")
    flake.inputs.nix-colors.homeManagerModule
  ];

  colorScheme = import ../../modules/colorSchemes/gruvbox-material.nix;

  home.file.".config/x11/xinitrc".text = ''
    #!/bin/sh

      ### screen ###
    xrandr --output eDP1 --gamma 1 --set "Broadcast RGB" "Full"

      ### app ###
    pidof -s dunst || setsid -f dunst &	    # dunst for notifications
    udiskie &				    # automount device daemon
    greenclip daemon &

      ### Settings ###
    xrandr --dpi 96 &
    xsetroot -cursor_name left_ptr &	    # change cursor name
    remaps &				    # remaps capslock with esc
    unclutter &				    # remove mouse when idle

      ### Visual ###
    laptop-bar &
    picom --experimental-backend &
    hsetroot -fill ${pkgs.wallpapers.gruvbox} &
    xrdb $HOME/.config/x11/xresources & xrdbpid=$!

    [ -n "$xrdbpid" ] && wait "$xrdbpid"

    ssh-agent dwm
    #while:; do dwm && break; done
  '';

    xresources.properties =
    let
      fontSize = 12;
    in {
    /* --- XFT --- */
    "Xft.dpi" = 85;
    /* --- Xterm --- */
      # Font
    "xterm*faceName" = "FantasqueSansMono Nerd Font Mono";
    "xterm*faceSize" = fontSize;

    /* --- Xresources --- */
      # Font
    "*.font" = "monospace:size=${toString fontSize}";

    "*.background" = "#${config.colorScheme.colors.background}";
    "*.foreground" = "#${config.colorScheme.colors.foreground}";
    "*.cursorColor" = "#${config.colorScheme.colors.cursorColor}";
      # Black + DarkGrey
    "*.color0"  = "#${config.colorScheme.colors.black}";
    "*.color8" = "#${config.colorScheme.colors.blackBright}";
      # DarkRed + Red
    "*.color1" = "#${config.colorScheme.colors.red}";
    "*.color9" = "#${config.colorScheme.colors.redBright}";
      # DarkGreen + Green
    "*.color2" = "#${config.colorScheme.colors.green}";
    "*.color10" = "#${config.colorScheme.colors.greenBright}";
      # DarkYellow + Yellow
    "*.color3" = "#${config.colorScheme.colors.yellow}";
    "*.color11" = "#${config.colorScheme.colors.yellowBright}";
      # DarkBlue + Blue
    "*.color4" = "#${config.colorScheme.colors.blue}";
    "*.color12" = "#${config.colorScheme.colors.blueBright}";
      # DarkMagenta + Magenta
    "*.color5" = "#${config.colorScheme.colors.magenta}";
    "*.color13" = "#${config.colorScheme.colors.magentaBright}";
      # DarkCyan + Cyan
    "*.color6" = "#${config.colorScheme.colors.cyan}";
    "*.color14" = "#${config.colorScheme.colors.cyanBright}";
      # LightGrey + White
    "*.color7" = "#${config.colorScheme.colors.white}";
    "*.color15" = "#${config.colorScheme.colors.whiteBright}";
  };


#  home.persistence = {
#    "/nix/persist/home/binette" = {
#      removePrefixDirectory = false;
#      allowOther = true;
#      directories = [
#        ".cache/BraveSoftware"
#        ".cache/Jellyfin Media Player"
#        ".cache/librewolf"
#        ".cache/qutebrowser"
#  
#        ".config/BraveSoftware"
#        ".config/jellyfin.org"
#        ".config/mutt"
#        ".config/nixpkgs"
#        ".config/shell"
#        ".config/tremc"
#  
#        ".local/bin"
#        ".local/share/applications"
#        ".local/share/cargo"
#        ".local/share/gnupg"
#        ".local/share/jellyfinmediaplayer"
#        ".local/share/Jellyfin Media Player"
#        ".local/share/password-store"
#        ".local/share/Ripcord"
#        ".local/share/xorg"
#        ".local/share/zoxide"
#        ".local/share/qutebrowser"
#  
#        ".git"
#        ".librewolf"
#        ".ssh"
#        ".gnupg"
#        ".zplug"
#  
#        "documents"
#        "pictures"
#        "videos"
#        "downloads"
#      ];
#       files = [
#        ".config/pulse/daemon.conf"
#        ".config/greenclip.toml"
#        ".config/wall.png"
#        ".config/zoomus.conf"
#        ".config/mimeapps.list"
#         ".local/share/history"
#         ".cache/greenclip.history"
#      ];
#    };
#  };

}
