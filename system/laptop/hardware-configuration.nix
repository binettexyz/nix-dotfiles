#!/run/current-system/sw/bin/nix
{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [ (modulesPath + "/installer/scan/not-detected.nix")
    ];

  boot.initrd.availableKernelModules = [ "xhci_pci" "ehci_pci" "ahci" "usb_storage" "sd_mod" "rtsx_pci_sdmmc" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/b4abc5fa-bd46-4f94-93ce-1e03ada99be4";
      fsType = "ext4";
    };

  fileSystems."/home" =
    { device = "/dev/disk/by-uuid/cd678c62-85dc-4b13-8a2a-d5f80da5298e";
      fsType = "ext4";
    };

#  fileSystems."/home/media/server/data" = {
#    device = "192.168.1.141:/data";
#    fsType = "nfs";
#  };

#  fileSystems."/home/media/server/home" = {
#    device = "192.168.1.141:/home";
#    fsType = "nfs";
#  };


  swapDevices = [ ];

}
