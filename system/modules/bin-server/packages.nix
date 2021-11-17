{ config, pkgs, ... }:

let

  unstable = import
    (builtins.fetchTarball https://github.com/nixos/nixpkgs/tarball/nixos-unstable)
    { config = config.nixpkgs.config; allowUnfree = true; };

in

  {

    programs = {
      adb.enable = true;
    };

    # List packages installed in system profile. To search, run:
    # $ nix search wget
    nixpkgs.config = {
      allowUnfree = true;
      packageOverrides = pkgs: rec {
        dwm-head      = pkgs.callPackage ./pkgs/dwm {};
        slstatus-head = pkgs.callPackage ./pkgs/slstatus {};
        st-head       = pkgs.callPackage ./pkgs/st {};
      };
    };

    environment.systemPackages = with pkgs; [

      # xorg
    xorg.xinit
    xorg.xev
    xorg.xmodmap

      # utilities
    wget git git-crypt dmenu xclip maim gcc exa hsetroot htop unclutter-xfixes trash-cli
    mediainfo chafa odt2txt atool unzip ntfs3g gnumake ffmpeg slop binutils bat
    xdotool xcape killall

      # programing language
    python3Minimal

      # media storage
    udiskie

      # shell
    zsh

      # media
    python39Packages.youtube-dl

      # editor
    vim neovim

      # file manager
    lf

      # suckless tools
    dwm-head
    slstatus-head
    st-head

      # encryption
    gnupg
    pinentry-qt # pinentry for gpg-agent

      # other
    wmname
    brave
    pulsemixer
    unstable.pamixer
    unclutter-xfixes
    unstable.mcrcon
    ];

}
