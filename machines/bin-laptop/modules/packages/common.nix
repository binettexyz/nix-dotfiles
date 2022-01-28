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
      systemPackages = with pkgs; [
        # sys
      zsh
      powerline-go
      nnn
      fzf
      sd
      bat
      cron
      dash
      wipe
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
      brightnessctl
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

        # monitoring
      bandwhich
      lm_sensors
      lsof
      gotop
      htop
      iotop
      lshw # lshardware
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
