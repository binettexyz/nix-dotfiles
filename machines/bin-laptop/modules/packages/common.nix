{ config, pkgs, lib, ... }:

  {

    # List packages installed in system profile. To search, run:
    # $ nix search wget
    nixpkgs.config = {
      allowUnfree = true;
      packageOverrides = pkgs: {
        unstable = import <nixos-unstable> {
          config = config.nixpkgs.config;
        };
      nur = import (builtins.fetchTarball "https://github.com/nix-community/NUR/archive/master.tar.gz") {
        inherit pkgs;
      };
        unstable-small = import <nixos-unstable-small> {
          config = config.nixpkgs.config;
        };
        small = import <nixos-small> {
          config = config.nixpkgs.config;
        };
        dwm-head = pkgs.callPackage ./pkgs/dwm {};
        st-head = pkgs.callPackage ./../user/binette/pkgs/st {};
        dmenu-head = pkgs.callPackage ./../user/binette/pkgs/dmenu {};
        slstatus-head = pkgs.callPackage ./../user/binette/pkgs/slstatus {};

      };
    };

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
      fzf
      sd
      bat
      cron
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
      nnn
      viu
      exa
      #zoxide # smarter cd command
      sshfs # mount directory over ssh
      ntfs3g
      rsync # replace scp

        # bells and whistles
      cava
      cmatrix

      nim
    ];
  };
}
