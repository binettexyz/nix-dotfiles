#!/bin/nix
{ config, pkgs, lib, modulesPath, ... }: {

  imports = [
      # Include the results of the hardware scan.
    "${fetchTarball "https://github.com/NixOS/nixos-hardware/archive/936e4649098d6a5e0762058cb7687be1b2d90550.tar.gz" }/raspberry-pi/4"
    (import "${home-manager}/nixos")
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

    # kernel stuff
  boot = {
    kernelPackages = pkgs.linuxPackages_rpi4;
    initrd.availableKernelModules = [ "usbhid" "usb_storage" ];
      # ttyAMA0 is the serial console broken out to the GPIO
    kernelParams = [
      "8250.nr_uarts=1"
      "console=ttyAMA0,115200"
      "console=tty1"
      "cma=128M" # Some gui programs need this
    ];
  };


    # fileSystem
  fileSystems."/" = {
    device = "/dev/disk/by-label/NIXOS_SD";
    fsType = "ext4";
  };
  fileSystems."/home/media/exthdd" = {
    device = "/dev/disk/by-label/exthdd";
    fsType = "ntfs";
    options = [ "rw" "uid=1001" "gid=100" ];
  };

}
