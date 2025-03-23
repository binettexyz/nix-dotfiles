{ config, pkgs, lib, super, ... }:
let
  cfg = super.services.xserver.windowManager.dwm;
in {

  imports = [
    ./dunst.nix
    ./flameshot.nix
    ./picom.nix
    ./sxhkd
  ];

  home.packages = lib.mkIf cfg.enable [
    pkgs.dmenu
    pkgs.dwm
    pkgs.st
  ];

}
