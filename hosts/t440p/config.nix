{ config, flake, lib, pkgs, system, ... }: {

  imports = [
    ./hardware.nix
    ../../nixos/default.nix
    flake.inputs.sops-nix.nixosModules.sops
    flake.inputs.impermanence.nixosModules.impermanence 
  ];

  #---Custom modules---#
  modules = { bootloader = "grub"; };
  device = {
    type = "laptop";
    netDevices = [ "enp0s25" "wlan0" ];
  };

}
