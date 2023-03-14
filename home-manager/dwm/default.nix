{ config, pkgs, inputs, lib, ... }:
let
  cfg = config.modules.type.laptop;
  dmenu = pkgs.callPackage (inputs.dmenu + "/default.nix") {};
  dwm = pkgs.callPackage (inputs.dwm + "/default.nix") {};
#  slstatus-desktop = pkgs.callPackage (inputs.slstatus-desktop + "/default.nix") {};
#  slstatus-laptop = pkgs.callPackage (inputs.slstatus-laptop + "/default.nix") {};
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
  ]; # ++ (if config.modules.device.type == "laptop" then [ slstatus-laptop ] else [ slstatus-desktop ]);

}
