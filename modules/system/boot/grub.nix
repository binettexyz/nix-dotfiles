{ config, pkgs, lib, ... }:
with lib;

let
  cfg = config.modules.bootloader;
in
{

  options.modules.bootloader = mkOption {
      description = "Enable bootloader";
      type = types.enum [ "grub" ];
      default = null;
  };

  config = mkIf (cfg == "grub") {

    boot = {
      plymouth.enable = false;
      loader = {
        efi = {
          canTouchEfiVariables = lib.mkDefault true;
          efiSysMountPoint = "/boot";
        };
      # Grub bootloader
        grub = {
          enable = true;
          version = 2;
          device = "nodev";
          efiSupport = true;
          gfxmodeEfi = "1280x720";
          useOSProber = true;
          backgroundColor = lib.mkDefault "#000000";
          splashImage = null;
          splashMode = "normal";
          extraConfig = ''
            set menu_color_normal=white/black
            set menu_color_highlight=black/white
          '';
          extraEntries = ''
            menuentry "Poweroff" {
	            halt
           }
	          menuentry "Reboot" {
             reboot
            }
          '';
        };
      };
    };
  };

}
