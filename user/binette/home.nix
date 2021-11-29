{ config, pkgs, ... }:

let
  unstable = import
    (builtins.fetchTarball https://github.com/nixos/nixpkgs/tarball/nixos-unstable)
    { config = config.nixpkgs.config; allowUnfree = true; };


  dwm-head      = pkgs.callPackage ./pkgs/dwm/default.nix {};
  dmenu-head    = pkgs.callPackage ./pkgs/dmenu/default.nix {};
  slstatus-head = pkgs.callPackage ./pkgs/slstatus/default.nix {};
  st-head       = pkgs.callPackage ./pkgs/st/default.nix {};

in

  {

    programs.git = {
      enable = true;
      userName = "Binetto";
      userEmail = "46168797+Binetto@users.noreply.github.com";
      extraConfig = {
        credential.helper = "cache";
      };
    };

  nixpkgs.config.allowUnfree = true;

  home = {
    username = "binette";
    homeDirectory = "/home/binette";
    packages = with pkgs; [
        # browser
      brave
      qutebrowser
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
      dunst libnotify

        # editor
      emacs

      dwm-head
      dmenu-head
      slstatus-head
      st-head

       # others
      unclutter-xfixes # remove mouse wen idle
      unstable.mcrcon # minecraft rcon client
      xcompmgr # compositor (transparency)
      betterlockscreen
    ];

  };

}
