{ config, flake, pkgs, ... }:

let
  inherit (flake) inputs;
in {

  imports = [
    ../../home-manager/desktop.nix
#    (flake.inputs.impermanence + "/home-manager.nix")
    flake.inputs.nix-colors.homeManagerModule
  ];

  colorScheme = import ../../modules/colorSchemes/gruvbox-material.nix;

#  home.file.".config/x11/xinitrc".text = ''
#    #!/bin/sh
#    # vim: ft=sh
#
#      ### screen ###
#    xrandr --output DP-2 --gamma 1 # --set "Broadcast RGB" "Full"
#
#      ### Settings ###
##    xrandr --dpi 96
#    xsetroot -cursor_name left_ptr &	    # change cursor name
#
#      ### Visual ###
#    hsetroot -fill ${pkgs.wallpapers.gruvbox} &
#    xrdb $HOME/.config/x11/xresources & xrdbpid=$!
#
#    [ -n "$xrdbpid" ] && wait "$xrdbpid"
#  '';

#  home.persistence."/nix/persist/home/binette" = {
#    removePrefixDirectory = false;
#    allowOther = true;
#    directories = [
#      ".cache/lutris"
#      ".cache/librewolf"
#      
#      ".config/lutris"
#      ".config/retroarch"
#      ".config/shell"
#      ".config/discord"
#      ".config/sops"
#      ".config/tidal-hifi"
#      
#      ".local/bin"
#      ".local/share/applications"
#      ".local/share/cargo"
#      ".local/share/games"
#      ".local/share/gnupg"
#      ".local/share/lutris"
#      ".local/share/nvim"
#      ".local/share/password-store"
#      ".local/share/PrismLauncher"
#      ".local/share/Steam"
#      ".local/share/xorg"
#      ".local/share/zoxide"
#
#      ".git"
#      ".librewolf"
#      ".ssh"
#      ".steam"
#      ".gnupg"
#      ".zplug"
#
#      "documents"
#      "pictures"
#      "videos"
#      "downloads"
#    ];
#
#    files = [
#      ".config/pulse/daemon.conf"
#
#      ".local/share/history"
#    ];
#  };

}
