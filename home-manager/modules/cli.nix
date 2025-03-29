{ config, lib, pkgs, ... }: {

  home.packages = with pkgs; [
    bat
    cron
    curl
    eza
    fzf
#    gcc
#    gnumake
    gnused
    htop
    killall
    ncdu
#    nix-tree
    ouch #easily compressing and decompressing files and directories
#   pinentry pinentry-qt pass
#    pwgen # password generator
    rsync # replace scp
    wget
    yt-dlp

    # Archive tools
    atool
    zip
    unzip
    rar
  ];

}
