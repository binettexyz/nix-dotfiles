{ config, pkgs, ... }: {

  imports =
   [
#     ../modules/nixpkgsConfig.nix
#     ../services/nix.nix
#     ../services/localization.nix
#     ../services/net/transmission.nix
#     ../services/net/tailscale.nix
#     ../services/net/ssh.nix
     ../services/net/adguard.nix
     ../services/net/torrents.nix
#     ../services/x/x.nix
#     ../services/x/systemd.nix
#     ../services/x/tmux.nix
#     ../system/fonts.nix
#     ../system/security.nix
     ../users/server
    ];


    environment.systemPackages = with pkgs; [
#      # system
#    zsh
#    neovim
#    powerline-go
#    bat # cat clone with syntax highlighting
#    cron
#    wipe # command to wipe drives
#    git git-crypt
#    gcc
#    trash-cli
#    wget
#    curl
#    gnumake
#    binutils
#    killall
#    fzf
#      # pass
#    bitwarden-cli
#      # monitoring
#    lm_sensors
#    htop
#      # file system
#    file
#    mediainfo
#    chafa
#    odt2txt
#    python39Packages.pdftotext
#    ueberzug
#    ffmpegthumbnailer
#    imagemagick
#    poppler
#    wkhtmltopdf
#    zip
#    unzip
#    unrar
#    atool
#    lf
#    exa
#    ntfs3g
#    rsync
#    parted
      # torrent
    unstable.sonarr
    unstable.radarr
    unstable.jackett
    unstable.plex
    ];

    services = {
      jackett = {
        enable = true;
      };
      sonarr = {
        enable = true;
      };
      radarr = {
        enable = true;
      };
      plex = {
        enable = true;
      };
    };

      # don't install documentation i don't use
    documentation.enable = lib.mkForce false; # documentation of packages
#    documentation.nixos.enable = false; # nixos documentation
#    documentation.man.enable = true; # manual pages and the man command
#    documentation.info.enable = false; # info pages and the info command
#    documentation.doc.enable = false; # documentation distributed in packages' /share/doc


}
