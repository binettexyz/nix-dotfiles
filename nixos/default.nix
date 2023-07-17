{ config, lib, pkgs, flake, ... }: {

  imports = [
    ./audio.nix
    ./desktop.nix
    ./dev.nix
    ./fonts.nix
    ./home.nix
    ./kde
    ./laptop
    ./minimal.nix
    ./pc.nix
    ./xserver.nix
  ];

}
