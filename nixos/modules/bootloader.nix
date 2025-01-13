{ config, pkgs, lib, ... }:
with lib;
let
  cfg = config.modules.bootloader.default;
in {

  /* ---Bootloader Modules--- */
  options.modules.bootloader = {
    default = mkOption {
      description = "Enable bootloader";
      type = types.enum [ "grub" "systemd" "rpi4" ];
      default = "grub";    
    };
    asRemovable = mkOption {
      description = "Enable efiInstallAsRemovable option.";
      default = false;
    };
    useOSProber = mkOption {
      description = "Enable OS-Prober.";
      default = false;
    };
  };

  /* ---Configuration--- */
  config = mkMerge [
    (mkIf (cfg == "grub") {
      boot = {
        plymouth.enable = false;
        loader = {
          timeout = 1;
          efi = {
            canTouchEfiVariables = if config.modules.bootloader.asRemovable then false else true;
            efiSysMountPoint = "/boot";
          };
        # Grub bootloader
          grub = {
            enable = true;
            default = 0;
            device = "nodev";
            efiInstallAsRemovable = config.modules.bootloader.asRemovable;
            efiSupport = true;
            gfxmodeEfi = "1280x800";
            useOSProber = config.modules.bootloader.useOSProber;
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
