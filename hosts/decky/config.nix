{ config, lib, flake, pkgs, ... }:

let
  inherit (flake) inputs;
in {

  imports = [
    ./hardware.nix
    ../../nixos/steamdeck.nix
    flake.inputs.sops-nix.nixosModules.sops
    flake.inputs.impermanence.nixosModules.impermanence
    flake.inputs.jovian-nixos.nixosModules.jovian
  ];

  /* ---Custom modules--- */
  modules.system = {
    bootloader = {
      default = "grub";
      asRemovable = true;
      useOSProber = false;
    };
    desktopEnvironment = {
      default = "kde";
      steamdeck.enable = true;
    };
  };
  device = {
    gpu = "amd";
    netDevices = [ "wlo1" ];
  };

  /* ---Networking--- */
  networking = {
    interfaces.wlo1.useDHCP = true;
    interfaces.tailscale0.useDHCP = true;
  };

  /* ---Stuff I Dont Want--- */
  services.timesyncd.enable = lib.mkForce false;
}

