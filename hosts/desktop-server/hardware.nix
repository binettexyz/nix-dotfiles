{ config, flake, lib, modulesPath, pkgs, ... }:

{

  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    flake.inputs.nixos-hardware.nixosModules.common-cpu-amd
    flake.inputs.nixos-hardware.nixosModules.common-cpu-amd-pstate
    flake.inputs.nixos-hardware.nixosModules.common-gpu-nvidia-nonprime
  ];

  boot = {
    extraModulePackages = [ ];
    kernelModules = [ "kvm-amd" "nvidia" ];
    #kernelPackages =  pkgs.linuxPackages_xanmod;
    kernelParams = [ "nvidia_drm.modeset=1"  ];
    initrd = {
      availableKernelModules = [ "xhci_pci" "ahci" /*"nvme"*/ "usbhid" "usb_storage" "sd_mod" ];
      kernelModules = [ ];
    };
  };

  /* ---FileSystem--- */
  fileSystems = {
    "/" = { 
      device = "none";
      fsType = "tmpfs";
      options = [ "defaults" "size=2G" "mode=755" ];
    };
    "/boot" = {
      device = "/dev/disk/by-label/boot";
      fsType = "vfat";
    };
    "/nix" = {
      device = "/dev/disk/by-label/nix";
      fsType = "ext4";
    };
    "/home" = {
      device = "/dev/disk/by-label/home";
      fsType = "ext4";
    };
  };

  swapDevices = [ /*{ device = "/swap"; size = 1024 * 8; options = [ "mode=600"]; }*/ ];

  environment.persistence = {
    "/nix/persist" = {
      hideMounts = true;
      directories = [
        "/etc/nixos"
        "/var/lib"
        "/var/log"
        "/mounts"
        "/media"
        "/root"
        "/srv"
      ];
    };
  };

  /* ---Network--- */
  networking = {
    hostName = "desktop-server";
    interfaces.wlo1.useDHCP = true;
    interfaces.enp34s0.useDHCP = true;
    interfaces.tailscale0.useDHCP = true;
  };

  /* ---CPU Stuff--- */
  powerManagement.cpuFreqGovernor = lib.mkDefault "conservative";
  nix.settings.max-jobs = 16;
}
