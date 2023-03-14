{ config, lib, pkgs, ... }: {

  home.packages = with pkgs; [
    atool # archive tool
    bat
    bc # command line calculator
    binutils
    coreutils
    cron
    #TODO cryptsetup
    curl
    daemonize # runs a command as a Unix daemon
    dua # Tool to learn disk usage of directories
    exa
    file
    fzf
    gcc
    gnumake
    gnused
    htop
    ix # Command line pastbin
    jq
    killall
    lsof
    mediainfo
    ncdu
    nix-tree
    ouch #easily compressing and decompressing files and directories
#   pinentry pinentry-qt pass
    pwgen
    python3
    rsync # replace scp
    tig # text mode interface for git
    unzip
    wget
    yt-dlp
    xclip
    xcape
    zip
  ];

  xresources.path = "/home/binette/.config/x11/xresources";
  xresources.properties =
    let
      fontSize = (if config.modules.device.type =="laptop" then 14 else 16);
    in {
      /* --- Xft --- */
      "Xft.antialias" = 1;
      "Xft.hinting" = 1;
  #    "Xft.dpi" = 96;
      "Xft.rgba" = "rgb";
      "Xft.lcdfilter" = "lcddefault";
  
      /* --- Xterm --- */
      "xterm.termName" = "xterm-256color";
      "xterm.vt100.locale" = false;
      "xterm.vt100.utf8" = true;
        # Font
      "xterm*faceName" = "FantasqueSansMono Nerd Font Mono";
      "xterm*faceSize" = fontSize;
        # Backspace and escape fix
      "xterm.vt100.metaSendsEscape" = true;
      "xterm.vt100.backarrowKey" = false;
      "xtermttyModes" = "erase ^?";
  
      /* --- Xresources --- */
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
