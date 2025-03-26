{ config, flake, pkgs, ... }:

let
  inherit (flake) inputs;
in {

  imports = [
    ../../home-manager/gaming-desktop.nix
    (flake.inputs.impermanence + "/home-manager.nix")
    flake.inputs.nix-colors.homeManagerModule
  ];

  colorScheme = import ../../modules/colorSchemes/gruvbox-material.nix;

  home.file.".local/bin/autostart/seiryu.sh" = {
    executable = true;
    text = ''
      #!/bin/sh
      # vimL ft=sh

      # ---Settings--- #
      wl-randr --output HDMI-A-2 --pos 0,0    --mode 1920x1080@179 \
               --output HDMI-A-1 --pos 1920,0 --mode 3840x2160@120
      remaps &
      xrdb $HOME/.Xresources & xrdbpid=&!
      [ -n "$xrdbpid" ] && wait "$xrdbpid"
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
