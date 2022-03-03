{ config, pkgs, lib, ... }: {

  imports =
    [
      ../modules/nixpkgsConfig.nix
      ../services/grub.nix
      ../services/nix.nix
      ../services/localization.nix
      ../services/net/ssh.nix
      ../services/net/transmission.nix
      ../services/net/tailscale.nix
      ../services/x/x.nix
    ];

    # mount tmpfs on /tmp
  boot.tmpOnTmpfs = lib.mkDefault true;
  boot.cleanTmpDir = true;

  environment = {
    homeBinInPath = true;
    localBinInPath = true;
      # get rid of defaults packages like nano, perl and rsync
    defaultPackages = lib.mkForce [];
      # install basic packages
    systemPackages = with pkgs; [
        # sys
      # TODO: dash watchman
      # TODO: tomb pwgen cryptsetup
      zsh
      powerline-go
      sd # replace 'sed'
      bat # cat clone with syntax highlighting
      cron
      wipe # command to wipe drives
      xstow # dotfile manager
      git git-crypt
      gcc
      trash-cli
      lnav # logfile naviguator
      wget
      curl
      gnumake
      ffmpeg
      binutils
      xcape
      killall
      nfs-utils
      light
      youtube-dl
      woeusb # write win10.iso to usb drive
      mkpasswd
      fzf

        # pass
      pinentry-qt
      pass
      bitwarden bitwarden-cli

        # monitoring
      lm_sensors
      gotop

        # file system
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
      viu
      exa
      ntfs3g
      sshfs # mount directory over ssh
      rsync # replace scp
      parted

        # autre
      nim
    ];
  };

    # don't install documentation i don't use
  documentation.enable = true; # documentation of packages
  documentation.nixos.enable = false; # nixos documentation
  documentation.man.enable = true; # manual pages and the man command
  documentation.info.enable = false; # info pages and the info command
  documentation.doc.enable = false; # documentation distributed in packages' /share/doc

    # copy the system configuration into nix-store
  system.copySystemConfiguration = true;
}
