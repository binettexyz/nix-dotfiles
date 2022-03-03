#!/run/current-system/sw/bin/nix
# acpi_call makes tlp work for newer thinkpads

{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [ (modulesPath + "/installer/scan/not-detected.nix")
    ];

    # kernel modules/packages
  boot = {
    extraModulePackages = with config.boot.kernelPackages; [ acpi_call ];
    kernelModules = [];
    kernelPackages = pkgs.linuxPackages_latest;
    kernelParams = [];
    initrd = {
      availableKernelModules = [ "xhci_pci" "ehci_pci" "ahci" "usbhid" "usb_storage" "uas" "sd_mod" "rtsx_pci_sdmmc" ];
      kernelModules = [ "dm-snapshot" "cryptd" "usb_storage" "acpi_call" ];
    };
  };

      # luks encryption
    boot.loader.grub.enableCryptodisk = true;
    boot.initrd.luks = {
      reusePassphrases = true;
      devices.crypted = {
        device = "/dev/disk/by-uuid/3bdc652b-8ad3-40dc-ae59-bb51370c491a";
        keyFile = "/dev/disk/by-id/usb-General_UDisk-0:0";
        keyFileSize = 4096;
        preLVM = true;
        fallbackToPassword = true;
        bypassWorkqueues = true;
      };
    };

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-label/nixos";
      fsType = "ext4";
      options = [ "noatime" "discard" ];
    };
    "/boot" = {
      device = "/dev/disk/by-label/boot";
      fsType = "vfat";
      options = [ "noatime" "discard" ];
    };
    "/home" = {
      device = "/dev/disk/by-label/home";
      fsType = "ext4";
    };
    "/home/media/ventoy" = {
      device = "/dev/disk/by-label/Ventoy";
      fsType = "exfat";
    };
  };
#    "/home/media/server/home" = {
#      device = "192.168.1.141:/home";
#      fsType = "nfs";
#        # don't freeze system if mount point not available on boot
#      options = [ "x-systemd.automount" "noauto" ];
#    };

  swapDevices = [{ device = "/dev/disk/by-label/swap"; }];

}
