{ config, pkgs, ... }:

let
  unstable = import
    (builtins.fetchTarball https://github.com/nixos/nixpkgs/tarball/nixos-unstable)
    { config = config.nixpkgs.config; allowUnfree = true; };
in

  {

    # List packages installed in system profile. To search, run:
    # $ nix search wget
    nixpkgs.config = {
      allowUnfree = true;
      packageOverrides = pkgs: rec {
        dwm-head      = pkgs.callPackage /home/binette/.config/suckless/dwm {};
        slstatus-head = pkgs.callPackage /home/binette/.config/suckless/slstatus {};
        st-head       = pkgs.callPackage ./pkgs/st {};
      };
    };

    environment.systemPackages = with pkgs; [

      # nixos home-manager
    home-manager

      # xorg
    xorg.xinit
    xorg.xev
    xorg.xmodmap

      # utilities
    wget git git-crypt dmenu xclip maim gcc exa hsetroot htop unclutter-xfixes trash-cli
    mediainfo chafa odt2txt atool unzip ntfs3g gnumake ffmpeg slop binutils bat
    xdotool xcape killall lm_sensors

      # programing language
    python3Minimal

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

      # file manager
    lf

      # suckless tools
    dwm-head
    slstatus-head
    st-head

      # encryption
    gnupg
    pass pass-otp
    pinentry-qt # pinentry for gpg-agent

      # other
    light # backlight
    ];

    nix = {
      package = pkgs.nixFlakes;
      extraOptions = ''
        experimental-features = nix-command flakes
      '';
    };

}
