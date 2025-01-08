{ config, lib, pkgs, flake, ... }: {

  imports = [
    ./audio.nix
    ./desktop.nix
    ./dev.nix
    ./fonts.nix
    ./home.nix
    ./desktopEnvironment.nix
    ./laptop
    ./minimal.nix
    ./pc.nix
    ./xserver.nix
  ];

}
