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

  home.file.".config/x11/xprofile" = {
    executable = true;
    text = ''
      #!/bin/sh
      # vim: ft=sh
  
      remaps &				    # remaps capslock with esc
      xsetroot -cursor_name left_ptr &	    # change cursor name
      nvidia-settings --config=~/.config/.nvidia-settings-rc --load-config-only
      xrdb $HOME/.config/x11/xresources & xrdbpid=$!
      [ -n "$xrdbpid" ] && wait "$xrdbpid"
  
    '';
  };

  home.file.".xprofile" = {
    executable = true;
    text = ".config/x11/xprofile";
  };

  home.file.".config/x11/xinitrc" = {
    executable = true;
    text = ''
      #!/bin/sh
      # vim: ft=sh
  
        ### screen ###
      xrandr --output DP-2 --gamma 1 # --set "Broadcast RGB" "Full"
  
        ### app ###
      pidof -s dunst || setsid -f dunst &	    # dunst for notifications
      udiskie &				    # automount device daemon
      flameshot &
      greenclip daemon &
  
        ### Visual ###
      desktop-bar &       # dwm status bar
      picom --experimental-backends &
      hsetroot -fill ${pkgs.wallpapers.gruvbox} &

      if [ -f "$HOME/.config/x11/xprofile" ]; then
  	          . "$HOME/.config/x11/xprofile"
      else
  	          . "$HOME/.xprofile"
      fi

      while :; do dwm && break; done
    '';
  };

  xresources.properties =
    let
      fontSize = 12;
    in {
    /* --- XFT --- */
    "Xft.dpi" = 96;
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

}
