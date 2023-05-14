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
  xresources.properties = {
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
        # Backspace and escape fix
      "xterm.vt100.metaSendsEscape" = true;
      "xterm.vt100.backarrowKey" = false;
      "xtermttyModes" = "erase ^?";
    };

}
