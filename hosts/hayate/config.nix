{ config, flake, ... }:
let
inherit (config.meta) username;
in {
  imports = [
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
    system = {
      audio.enable = true;
      customFonts.enable = true;
      desktopEnvironment = "hyprland-uwsm";
      home.enable = true;
    };
  };

  #device.videoOutput = [""];

  boot.loader.grub = {
    enableCryptodisk = true;
  };

  boot.initrd.luks.devices = {
    crypted = {
      device = "/dev/disk/by-uuid/a4fe62f9-d991-422c-a605-fde380d92d29";
      preLVM = true;
    };
  };

}
