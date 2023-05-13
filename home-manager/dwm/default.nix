{ config, pkgs, lib, ... }: {

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
