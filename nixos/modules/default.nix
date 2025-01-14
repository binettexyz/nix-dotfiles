{ config, lib, pkgs, flake, ... }: {

  imports = [
    ./audio.nix
    ./bootloader.nix
    ./environmentVariables.nix
    ./desktopEnvironment.nix
    #./dev.nix
    ./fonts.nix
    ./gaming
    ./home.nix
    ./jovian-nixos.nix
    ./laptop
    ./locale.nix
    ./meta.nix
    ./network.nix
    ./pc.nix
    ./security.nix
    ./server
    ./ssh.nix
    ./system.nix
    ./user.nix
    ./xserver.nix
  ];

}