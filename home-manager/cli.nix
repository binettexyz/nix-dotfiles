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
#        "Xft.dpi" = 96;
    "Xft.rgba" = "rgb";
    "Xft.lcdfilter" = "lcddefault";
      # Stuff
    "xterm.termName" = "xterm-256color";
    "xterm.vt100.locale" = false;
    "xterm.vt100.utf8" = true;
    
      # Font
    "xterm*faceName" = "FantasqueSansMono Nerd Font Mono";
    "xterm*faceSize" = 14;
        
          # Gruvbox-Material
#    "xtermcolor0" = "#171717";
#    "xtermcolor1" = "#cc241d";
#    "xtermcolor2" = "#98971a";
#    "xtermcolor3" = "#d79921";
#    "xtermcolor4" = "#458588";
#    "xtermcolor5" = "#de6809";
#    "xtermcolor6" = "#689d6a";
#    "xtermcolor7" = "#bdae93";
#    "xtermcolor8" = "#253340";
#    "xtermcolor9" = "#fb4934";
#    "xtermcolor10" ="#b8bb26";
#    "xtermcolor11" ="#fabd2f";
#    "xtermcolor12" ="#83a598";
#    "xtermcolor13" ="#fe8019";
#    "xtermcolor14" ="#8ec07c";
#    "xtermcolor15" ="#ebdbb2";
#    "xtermbackground" = "#171717";
#    "xtermforeground" = "#ebdbb2";
#    "xtermhighlightColor" = "#405055";
    
      # Backspace and escape fix
    "xterm.vt100.metaSendsEscape" = true;
    "xterm.vt100.backarrowKey" = false;
    "xtermttyModes" = "erase ^?";
    
  };
  xresources.extraConfig = ''
    *.font: monospace:size=14
    ! #282828
    *background: #000000
    *foreground: #ebdbb2
    ! Black + DarkGrey
    ! #282828
    *color0:  #000000
    *color8:  #928374
    ! DarkRed + Red
    *color1:  #cc241d
    *color9:  #fb4934
    ! DarkGreen + Green
    *color2:  #98971a
    *color10: #b8bb26
    ! DarkYellow + Yellow
    *color3:  #d79921
    *color11: #fabd2f
    ! DarkBlue + Blue
    *color4:  #458588
    *color12: #83a598
    ! DarkMagenta + Magenta
    *color5:  #b16286
    *color13: #d3869b
    ! DarkCyan + Cyan
    *color6:  #689d6a
    *color14: #8ec07c
    ! LightGrey + White
    *color7:  #a89984
    *color15: #ebdbb2
  '';

}
