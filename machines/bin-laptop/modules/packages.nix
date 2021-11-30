{ config, pkgs, ... }:

#let
#  unstable = import
#    (builtins.fetchTarball https://github.com/nixos/nixpkgs/tarball/nixos-unstable)
#    { config = config.nixpkgs.config; allowUnfree = true; };
#
#in

  {

    programs = {
      adb.enable = true;
    };

    # List packages installed in system profile. To search, run:
    # $ nix search wget
    nixpkgs.config = {
      allowUnfree = true;
      packageOverrides = pkgs: {
        unstable = import <nixos-unstable> {
          config = config.nixpkgs.config;
        };
        unstable-small = import <nixos-unstable-small> {
          config = config.nixpkgs.config;
        };
        small = import <nixos-small> {
          config = config.nixpkgs.config;
        };
      };
    };

    environment = {
      homeBinInPath = true;
      systemPackages = with pkgs; [

          # nixos home-manager
        home-manager

          # xorg
        xorg.xinit
        xorg.xev
        xorg.xmodmap

          # utilities
        wget git git-crypt xclip maim gcc exa hsetroot htop unclutter-xfixes trash-cli
        mediainfo chafa odt2txt atool unzip ntfs3g gnumake ffmpeg slop binutils bat
        xdotool xcape killall lm_sensors

          # browser
        firefox

          # media storage
        udiskie

          # shell
        zsh

          # media
        mpv sxiv zathura python39Packages.youtube-dl

          # editor
        vim neovim
        unstable.vscodium

          # file manager
        lf

          # terminal
        kitty

          # encryption
        gnupg
        pass pass-otp
        pinentry-qt # pinentry for gpg-agent

          # server
        nfs-utils

          # other
        light # backlight
        wmname
        cmatrix

          # clipboard manager
          haskellPackages.greenclip
      ];
    };

    nix = {
      package = pkgs.nixFlakes;
      extraOptions = ''
        experimental-features = nix-command flakes
      '';
    };

}
