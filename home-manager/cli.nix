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

}
