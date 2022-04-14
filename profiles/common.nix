#!/bin/nix
{ config, pkgs, lib, ... }: {

  imports =
    [
      ../modules/nixpkgsConfig.nix
      ../services/grub.nix
      ../services/nix.nix
      ../services/localization.nix
      ../services/net/ssh.nix
#      ../services/net/transmission.nix
      ../services/net/tailscale.nix
      ../services/net/syncthing.nix
      ../services/x/x.nix
      ../services/x/systemd.nix
      ../services/x/tmux.nix
      ../system/fonts.nix
      ../system/security.nix
    ];

    # mount tmpfs on /tmp
  boot.tmpOnTmpfs = lib.mkDefault true;
  boot.cleanTmpDir = true;

    # enable Font/DPI configuration optimized for HiDPI displays
  hardware.video.hidpi.enable = true;

    # Set environment variables
#  environment.variables = {
#    NIXOS_CONFIG="/etc/nixos/machines/x240/configuration.nix";
#    EDITOR="nvim";
#  };

  environment = {
    localBinInPath = true;
      # get rid of defaults packages like nano, perl and rsync
    defaultPackages = lib.mkForce [ ];
      # install basic packages
    systemPackages = with pkgs; [
        # sys
      # TODO: dash watchman
      # TODO: tomb pwgen cryptsetup
      zsh
      neovim
      powerline-go
      dash
#      sd # replace 'sed'
      bat # cat clone with syntax highlighting
      cron
      wipe # command to wipe drives
#      xstow # dotfile manager
      git git-crypt
      gcc
      trash-cli
#      lnav # logfile naviguator
      wget
      curl
      gnumake
#      ffmpeg
      binutils
#      xcape
      killall
#      nfs-utils
#      youtube-dl
#      woeusb # write win10.iso to usb drive
#      mkpasswd
      fzf
        # internet
#      wireguard-tools
        # pass
      pinentry-qt
      pass
      bitwarden-cli # bitwarden

        # monitoring
      lm_sensors
      htop

        # file system
      file
      mediainfo
      chafa
      odt2txt
      python39Packages.pdftotext
      ueberzug
      ffmpegthumbnailer
      imagemagick
      poppler
      wkhtmltopdf
      zip
      unzip
      unrar
      atool
      lf
#      viu # image viewer in terminal
      exa
      ntfs3g
#      sshfs # mount directory over ssh
      rsync # replace scp
      parted

        # autre
#      nim
    ];
  };

    # don't install documentation i don't use
  documentation.enable = lib.mkDefault true; # documentation of packages
  documentation.nixos.enable = lib.mkDefault false; # nixos documentation
  documentation.man.enable = lib.mkDefault true; # manual pages and the man command
  documentation.info.enable = lib.mkDefault false; # info pages and the info command
  documentation.doc.enable = lib.mkDefault false; # documentation distributed in packages' /share/doc

    # copy the system configuration into nix-store
  system.copySystemConfiguration = true;

}
