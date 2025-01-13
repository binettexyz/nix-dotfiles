{ config, flake, lib, pkgs, system, ... }: {

  imports = [
    ./hardware.nix
    ../../nixos/laptop.nix
    flake.inputs.sops-nix.nixosModules.sops
    flake.inputs.impermanence.nixosModules.impermanence 
  ];

  #---Custom modules---#
  modules = {
    bootloader = {
      default = "grub";
      asRemovable = false;
      useOSProber = false;
    };
  };

  device.netDevices = [ "enp0s25" "wlan0" ];

}
