{ config, pkgs, inputs, lib, ... }:
let
  dmenu = pkgs.callPackage (inputs.dmenu + "/default.nix") {};
  dwm = pkgs.callPackage (inputs.dwm + "/default.nix") {};
  st = pkgs.callPackage (inputs.st + "/default.nix") {};
in
{

  imports = [
    ./dunst.nix
    ./flameshot.nix
    ./picom.nix
    ./sxhkd
  ];

  home.packages = with pkgs; [
    dmenu
    dwm
    st
  ];

}
