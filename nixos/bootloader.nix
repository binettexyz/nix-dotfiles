{ config, pkgs, lib, ... }:
with lib;
let
  cfg = config.modules.bootloader;
in
{

  options.modules.bootloader = mkOption {
      description = "Enable bootloader";
      type = types.enum [ "grub" "systemd" "rpi4" ];
      default = "grub";
  };

  config = mkMerge [
    (mkIf (cfg == "grub") {
      boot = {
        plymouth.enable = false;
        loader = {
          timeout = 1;
          efi = {
            canTouchEfiVariables = lib.mkDefault true;
            efiSysMountPoint = "/boot";
          };
        # Grub bootloader
          grub = {
            enable = true;
            default = 4;
            device = "nodev";
            efiSupport = true;
            gfxmodeEfi = "1366x768";
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
    })
    (mkIf (cfg == "systemd") {
    })
    (mkIf (cfg == "rpi4") {
      boot.loader = {
        efi.canTouchEfiVariables = lib.mkForce false;
        generic-extlinux-compatible.enable = true;
        grub.enable = lib.mkForce false;
      };
    })
  ];

}
