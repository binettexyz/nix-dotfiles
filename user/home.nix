{ config, pkgs, ... }:

let
  unstable = import
    (builtins.fetchTarball https://github.com/nixos/nixpkgs/tarball/nixos-unstable)
    { config = config.nixpkgs.config; allowUnfree = true; };
in

  {

  nixpkgs.config.allowUnfree = true;

  home = {
    username = "binette";
    homeDirectory = "/home/binette";
    packages = with pkgs; [
        # browser
      brave
      qutebrowser
#      ungoogled-chromium
      unstable.zoom-us

        # media
      discord
      spotify

        # graphical tools
      geany # editor
      pcmanfm # file manager

        # audio mixer
      pulsemixer
      unstable.pamixer

        # Keybind-Manager daemon
      sxhkd

       # notification-daemon
      dunst

        # torrent
      transmission
      plex

        # editor
      emacs

       # others
      unclutter-xfixes # remove mouse wen idle
      unstable.mcrcon # minecraft rcon client
      xcompmgr # compositor (transparency)
      i3lock
    ];

  };

}
