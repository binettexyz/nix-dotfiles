{ config, lib, pkgs, ... }:

{
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
  xresources.properties = {
      #Xft related stuff
    "Xft.antialias" = 1;
    "Xft.hinting" = 1;
#    "Xft.dpi" = 96;
    "Xft.rgba" = "rgb";
    "Xft.lcdfilter" = "lcddefault";
      # Stuff
    "xterm.termName" = "xterm-256color";
    "xterm.vt100.locale" = false;
    "xterm.vt100.utf8" = true;
    
      # Font
    "xterm*faceName" = "FantasqueSansMono Nerd Font Mono";
    "xterm*faceSize" = 14;
        
      # Backspace and escape fix
    "xterm.vt100.metaSendsEscape" = true;
    "xterm.vt100.backarrowKey" = false;
    "xtermttyModes" = "erase ^?";

    /* --- Xresources --- */
    "*.font" = "monospace:size=14";
    "*background" = "#${config.colorScheme.colors.base00}";
    "*foreground" = "#${config.colorScheme.colors.base0F}";
      # Black + DarkGrey
    "*color0"  = "#${config.colorScheme.colors.base00}";
    "*color8" = "#${config.colorScheme.colors.base08}";
      # DarkRed + Red
    "*color1" = "#${config.colorScheme.colors.base01}";
    "*color9" = "#${config.colorScheme.colors.base09}";
      # DarkGreen + Green
    "*color2" = "#${config.colorScheme.colors.base02}";
    "*color10" = "#${config.colorScheme.colors.base0A}";
      # DarkYellow + Yellow
    "*color3" = "#${config.colorScheme.colors.base03}";
    "*color11" = "#${config.colorScheme.colors.base0B}";
      # DarkBlue + Blue
    "*color4" = "#${config.colorScheme.colors.base04}";
    "*color12" = "#${config.colorScheme.colors.base0C}";
      # DarkMagenta + Magenta
    "*color5" = "#${config.colorScheme.colors.base05}";
    "*color13" = "#${config.colorScheme.colors.base0D}";
      # DarkCyan + Cyan
    "*color6" = "#${config.colorScheme.colors.base06}";
    "*color14" = "#${config.colorScheme.colors.base0E}";
      # LightGrey + White
    "*color7" = "#${config.colorScheme.colors.base07}";
    "*color15" = "#${config.colorScheme.colors.base0F}";
  };

}
