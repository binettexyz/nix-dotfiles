{ config, pkgs, flake, ... }:
let
  inherit (flake) inputs;
in {

  imports = [
    ../../home-manager/desktop.nix
    (flake.inputs.impermanence + "/home-manager.nix")
    flake.inputs.nix-colors.homeManagerModule
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

  xresources.properties =
    let
      fontSize = 14;
    in {
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

      "Documents"
      "Pictures"
      "Videos"
      "Downloads"
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
