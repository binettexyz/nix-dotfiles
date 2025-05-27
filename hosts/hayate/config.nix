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
      device = "/dev/disk/by-uuid/5c4d86fb-32ef-4aae-8e1e-7bc5a8dcc2bc";
      preLVM = true;
    };
  };

}
