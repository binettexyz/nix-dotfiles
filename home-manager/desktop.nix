{ config, lib, pkgs, ... }: {

  imports = [
    ./modules/gaming.nix
    ./modules/pc.nix
  ];

  home.packages = with pkgs; [
    (calibre.override { unrarSupport = true; })
    discord
    solaar
    tidal-hifi
  ];

}

