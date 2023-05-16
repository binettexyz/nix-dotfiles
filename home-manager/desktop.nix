{ config, lib, pkgs, ... }: {

  imports = [
    ./gaming.nix
    ./pc.nix
  ];

  home.packages = with pkgs; [
    (calibre.override { unrarSupport = true; })
    discord
    solaar
    tidal-hifi
  ];

}

