#!/run/current-system/sw/bin/nix
{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [ (modulesPath + "/installer/scan/not-detected.nix")
    ];

  boot = {
    initrd = {
      availableKernelModules = [ "xhci_pci" "ehci_pci" "ahci" "usbhid" "usb_storage" "uas" "sd_mod" "rtsx_pci_sdmmc" ];
      kernelModules = [ "dm-snapshot" "cryptd" "usb_storage" ];
    };
    extraModulePackages = [ ];
    kernelModules = [ ];
    kernelPackages = pkgs.linuxPackages_latest;
    kernelParams = [ "video=DisplayPort-0:2560x1440@165" ];
  };

  fileSystems."/" =
    { device = "/dev/disk/by-label/nixos";
      fsType = "ext4";
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-label/boot";
      fsType = "vfat";
    };

  fileSystems."/home" =
    { device = "/dev/disk/by-label/home";
      fsType = "ext4";
    };

  fileSystems."/home/media/ventoy" =
    { device = "/dev/disk/by-label/Ventoy";
      fsType = "exfat";
    };

#  fileSystems."/home/media/server/home" = {
#    device = "192.168.1.141:/home";
#    fsType = "nfs";
#      # don't freeze system if mount point not available on boot
#    options = [ "x-systemd.automount" "noauto" ];
#  };


  swapDevices = [
    { device = "/dev/disk/by-label/swap"; }
  ];

}
