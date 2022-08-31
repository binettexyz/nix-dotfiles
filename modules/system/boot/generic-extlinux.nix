{ config, pkgs, lib, ... }:
with lib;

let
  cfg = config.modules.bootloader;
in
{

  options.modules.bootloader = mkOption {
      description = "Enable Generic-Extlinux-Compatible bootloader";
      type = types.enum [ "generic-extlinux" ];
      default = null;
  };

  config = mkIf (cfg == "generic-extlinux") {
    boot.loader = {
      efi.canTouchEfiVariables = lib.mkForce false;
      generic-extlinux-compatible.enable = true;
      grub.enable = lib.mkForce false;
    };
  };
}
