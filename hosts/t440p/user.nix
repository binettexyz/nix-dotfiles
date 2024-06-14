{ config, pkgs, flake, ... }:
let
  inherit (flake) inputs;
in {

  imports = [
    ../../home-manager/laptop.nix 
    (inputs.impermanence + "/home-manager.nix")
    flake.inputs.nix-colors.homeManagerModule
    flake.inputs.nixvim.homeManagerModules.nixvim
  ];


  /* ---Xinitrc Config--- */
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
    xrandr --dpi 96
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
  '';

  /* ---Xresources/Colorscheme--- */
  colorScheme = import ../../modules/colorSchemes/gruvbox-material.nix;
  xresources.properties = let fontSize = 12; in {
    ## Xterm ##
    "xterm*faceName" = "FantasqueSansMono Nerd Font Mono";
    "xterm*faceSize" = fontSize;

    ## Xresources ##
    "*.font" = "monospace:size=${toString fontSize}";
    "*.background" = "#${config.colorScheme.palette.background}";
    "*.foreground" = "#${config.colorScheme.palette.foreground}";
    "*.cursorColor" = "#${config.colorScheme.palette.cursorColor}";
      # Black + DarkGrey
    "*.color0"  = "#${config.colorScheme.palette.black}";
    "*.color8" = "#${config.colorScheme.palette.blackBright}";
      # DarkRed + Red
    "*.color1" = "#${config.colorScheme.palette.red}";
    "*.color9" = "#${config.colorScheme.palette.redBright}";
      # DarkGreen + Green
    "*.color2" = "#${config.colorScheme.palette.green}";
    "*.color10" = "#${config.colorScheme.palette.greenBright}";
      # DarkYellow + Yellow
    "*.color3" = "#${config.colorScheme.palette.yellow}";
    "*.color11" = "#${config.colorScheme.palette.yellowBright}";
      # DarkBlue + Blue
    "*.color4" = "#${config.colorScheme.palette.blue}";
    "*.color12" = "#${config.colorScheme.palette.blueBright}";
      # DarkMagenta + Magenta
    "*.color5" = "#${config.colorScheme.palette.magenta}";
    "*.color13" = "#${config.colorScheme.palette.magentaBright}";
      # DarkCyan + Cyan
    "*.color6" = "#${config.colorScheme.palette.cyan}";
    "*.color14" = "#${config.colorScheme.palette.cyanBright}";
      # LightGrey + White
    "*.color7" = "#${config.colorScheme.palette.white}";
    "*.color15" = "#${config.colorScheme.palette.whiteBright}";
  };

  /* ---Persistence--- */
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
