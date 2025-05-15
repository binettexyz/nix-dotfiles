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

  # ---Imports---
  imports = [
    #(flake.inputs.nixos-hardware + "/raspberry-pi/4")
    (modulesPath + "/installer/scan/not-detected.nix")
    flake.inputs.nixos-hardware.nixosModules.raspberry-pi-4
  ];

  # ---kernel modules/packages---
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
  };
  swapDevices = [ { device = "/swapFile" size = 1024 * 8; } ];

  # ---Networking---
  networking = {
    hostName = "kageyami";
    interfaces.eth0.useDHCP = true;
    interfaces.wlan0.useDHCP = true;
    wireless.interfaces = [ "wlan0" ];
  };

  nix.settings.max-jobs = 4;
  hardware.raspberry-pi."4".fkms-3d.enable = true;
  boot.tmp.useTmpfs = lib.mkForce false;
  powerManagement.cpuFreqGovernor = lib.mkForce "conservative";
}
