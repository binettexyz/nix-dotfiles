{ config, flake, pkgs, ... }:{

  imports = [ 
    ./hardware.nix
    ../../nixos/server.nix
    flake.inputs.sops-nix.nixosModules.sops
    flake.inputs.impermanence.nixosModules.impermanence 
  ];

  ## Custom modules ##
  modules = {
    bootloader = {
      default = "grub";
      asRemovable = false;
      useOSProber = false;
    };
  };

  device.netDevices = [ "enp34s0" "wlo1" ];

}
