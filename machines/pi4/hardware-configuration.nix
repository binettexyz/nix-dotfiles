#!/bin/nix
{ config, pkgs, lib, modulesPath, ... }: {

  imports = [
    "${fetchTarball "https://github.com/NixOS/nixos-hardware/archive/936e4649098d6a5e0762058cb7687be1b2d90550.tar.gz" }/raspberry-pi/4"
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

    # kernel stuff
  boot = {
    kernelPackages = pkgs.linuxPackages_rpi4;
    initrd.availableKernelModules = [ "xhci_pci" "usbhid" "usb_storage" ];
      # ttyAMA0 is the serial console broken out to the GPIO
    kernelParams = [
      "8250.nr_uarts=1"
      "console=ttyAMA0,115200"
      "console=tty1"
      "cma=128M" # Some gui programs need this
    ];
  };


    # fileSystem
  fileSystems = {
    "/" = {
      device = "none";
      fsType = "tmpfs";
      options = [ "default" "size=2G" "mode=755" ];
    };
    "/boot" = {
      device = "/dev/disk/by-label/boot";
      fsType = "vfat";
    };
    "/nix" = {
      device = "/dev/disk/by-label/nixos";
      fsType = "ext4";
    };
#    "/home/media/exthdd" = {
#      device = "/dev/disk/by-label/exthdd";
#      fsType = "ntfs";
#      options = [ "rw" "uid=1001" "gid=100" ];
#    };
  };

  swapDevices = [ ];

}
