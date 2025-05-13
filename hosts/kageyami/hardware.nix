{
  config,
  flake,
  lib,
  modulesPath,
  pkgs,
  system,
  ...
}:
{

  imports = [
    (flake.inputs.nixos-hardware + "/raspberry-pi/4")
    (modulesPath + "/installer/scan/not-detected.nix")
    flake.inputs.nixos-hardware.nixosModules.raspberry-pi-4
  ];

  # kernel modules/packages
  boot = {
    kernelPackages = pkgs.linuxPackages_rpi4;
    initrd.availableKernelModules = [
      "xhci_pci"
      "usbhid"
      "usb_storage"
    ];
    # ttyAMA0 is the serial console broken out to the GPIO
    kernelParams = [
      "8250.nr_uarts=1"
      "console=ttyAMA0,115200"
      "console=tty1"
      "cma=128M" # Some gui programs need this
    ];
  };

  # ---FileSystem---
  fileSystems = {
    "/" = {
      device = "/dev/disk/by-label/NIXOS_SD";
      fsType = "ext4";
    };
    "/nix" = {
      device = "/dev/disk/by-label/nix";
      fsType = "ext4";
    };
    #    "/nix/persist/home" = {
    #      device = "/dev/disk/by-label/home";
    #      fsType = "ext4";
    #    };
  };

  swapDevices = [ { device = "/dev/disk/by-label/swap"; } ];

  ##  Impermanence ##
  environment.persistence."/nix/persist" = {
    hideMounts = true;
    directories = [
      "/etc/nixos"
      "/home"
      "/mounts"
      "/root"
      "/srv"
      "/var/lib"
      "/var/log"
    ];
  };

  powerManagement.cpuFreqGovernor = lib.mkForce "conservative";
}
