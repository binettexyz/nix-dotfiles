{ config, pkgs, lib, ... }: {

  imports = [
    ../../modules/xprofile/desktop.nix
    ../../modules/discord
    ../../modules/virtualbox
  ];

  environment.systemPackages = with pkgs; [
    flameshot
    unstable.tidal-hifi
  ];

}


