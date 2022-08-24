{ config, pkgs, lib, ... }: {

  imports = [
    ../../modules/xprofile/desktop.nix
    ../../modules/discord
  ];

  environment.systemPackages = with pkgs; [
    flameshot
    unstable.tidal-hifi
  ];

}


