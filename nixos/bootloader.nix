{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.modules.bootloader.default;
in {
  # ---Bootloader Modules---
  options.modules.bootloader = {
    default = lib.mkOption {
      description = "Enable bootloader";
      type = lib.types.enum [
        "grub"
        "rpi4"
      ];
      default = "grub";
    };
    asRemovable = lib.mkOption {
      description = "Enable efiInstallAsRemovable option.";
      default = false;
    };
    useOSProber = lib.mkOption {
      description = "Enable OS-Prober.";
      default = false;
    };
  };

  # ---Configuration---
  config = lib.mkMerge [
    (lib.mkIf (cfg == "grub") {
      boot.loader = {
        timeout = 1;
        efi.canTouchEfiVariables =
          if config.modules.bootloader.asRemovable
          then false
          else true;
        efi.efiSysMountPoint = "/boot";
        grub = {
          enable = true;
          default = 0;
          device = "nodev";
          efiInstallAsRemovable = config.modules.bootloader.asRemovable;
          efiSupport = true;
          enableCryptodisk = true;
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
    })

    (lib.mkIf (cfg == "rpi4") {
      boot.loader = {
        efi.canTouchEfiVariables = lib.mkForce false;
        generic-extlinux-compatible.enable = true;
        grub.enable = lib.mkForce false;
      };
    })
  ];
}
