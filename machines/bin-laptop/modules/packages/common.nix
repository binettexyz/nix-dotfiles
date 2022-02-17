{ config, pkgs, lib, ... }:

  {

    environment = {
      variables = {
        VISUAL = "nvim";
        BROWSER = "brave";
        TERMINAL = "st";
      };
      homeBinInPath = true;
      localBinInPath = true;
        # get rid of defaults packages like nano, perl and rsync
      defaultPackages = lib.mkForce [];
      systemPackages = with pkgs; [
        # sys
      zsh
      powerline-go
      fzf
      sd
      bat
      cron
      dash
      wipe
      xstow
      #watchman
      git
      git-crypt
      gcc
      trash-cli
      mkpasswd
      file # file type viewer
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
      ddgr # cli duckduckgo
      #entr # ???
      #sampler
      #taskwarrior # todo & tasks
      procs
      #hyperfine
      woeusb # write win10.iso to usb drive

        # pass
       pinentry-qt
       pinentry-gtk2
       pinentry-gnome
       gopass
       pass
       bitwarden bitwarden-cli

        # monitoring
      bandwhich
      lm_sensors
      gotop
      pciutils # lspci
      usbutils # lsusb

        # sec
      #cryptsetup
      #tomb
      #pwgen

        # fs
      fd
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
      #zoxide # smarter cd command
      sshfs # mount directory over ssh
      rsync # replace scp
      parted

        # bells and whistles
      cava
      cmatrix

      nim
    ];
  };

}
