{ flake, ... }:
{

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
    modules.system = {
      audio.enable = true;
      customFonts.enable = true;
      desktopEnvironment = "qtile";
      home.enable = true;
    };
  };

}
