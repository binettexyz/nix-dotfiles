#!/run/current-system/sw/bin/nix
{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [ (modulesPath + "/installer/scan/not-detected.nix")
    ];

  boot = {
    initrd = {
      availableKernelModules = [ "xhci_pci" "ahci" "usbhid" "usb_storage" "sd_mod" ];
      kernelModules = [ ];
    };
    extraModulePackages = [ ];
    kernelModules = [ ];
    kernelPackages =  pkgs.linuxPackages_xanmod;
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

#  fileSystems."/home/media" = {
#    device = "@100.98.195.37:/home";
#    fsType = "nfs";
#      # don't freeze system if mount point not available on boot
#    options = [ "x-systemd.automount" "noauto" ];
#  };


  swapDevices = [ ];

}
