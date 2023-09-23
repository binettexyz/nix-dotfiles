{ config, lib, pkgs, ... }: {

  home.packages = with pkgs; [
    atool # archive tool
    bat
    #binutils
    #coreutils
    cron
    #TODO cryptsetup
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
    python3
    rsync # replace scp
    unzip
    wget
    yt-dlp
    xclip
    xcape
    zip
  ];

}
