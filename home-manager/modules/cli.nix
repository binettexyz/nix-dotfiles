{ config, lib, pkgs, ... }: {

  home.packages = with pkgs; [
    bat
    cron
    curl
    eza
    fzf
    gcc
    gnumake
    gnused
    htop
    jq
    killall
    ncdu
    nix-tree
    ouch #easily compressing and decompressing files and directories
#   pinentry pinentry-qt pass
    pwgen
    rsync # replace scp
    unzip
    wget
    yt-dlp
    xclip
    xcape
    zip
  ];

}
