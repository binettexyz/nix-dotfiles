#!/run/current-system/sw/bin/nix
{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [ (modulesPath + "/installer/scan/not-detected.nix")
    ];

  boot = {
    extraModulePackages = [ ];
    kernelModules = [ "kvm-amd" "nvidia" ];
    kernelPackages =  pkgs.linuxPackages_xanmod;
    kernelParams = [ "video=DisplayPort-0:2560x1440@165" ];
    initrd = {
      availableKernelModules = [ "xhci_pci" "ahci" "usbhid" "usb_storage" "sd_mod" ];
      kernelModules = [ ];
    };
  };

  fileSystems."/" =
    { device = "none";
      fsType = "tmpfs";
      options = [ "defaults" "size=2G" "mode=755" ];
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-label/boot";
      fsType = "vfat";
    };

  fileSystems."/nix" =
    { device = "/dev/disk/by-label/nix";
      fsType = "ext4";
    };

  fileSystems."/nix/persist/home" =
    { device = "/dev/disk/by-label/home";
      fsType = "ext4";
    };

  fileSystems."/media" = {
    device = "100.71.254.90:/media";
    fsType = "nfs";
      # don't freeze system if mount point not available on boot
    options = [ "x-systemd.automount" "noauto" ];
  };

  swapDevices = [ ];

    # hardware
  hardware.cpu.amd.updateMicrocode = true;
  services.xserver.videoDrivers = [ "nvidia" ];

}
