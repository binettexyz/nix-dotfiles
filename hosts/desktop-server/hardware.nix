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
    "/nix/persist/media" = {
      device = "/dev/disk/by-label/media";
      fsType = "ext4";
    };
    "/nix/persist/mounts/temp" = {
      device = "/dev/disk/by-label/exthdd";
      fsType = "ntfs-3g";
      options = [ "rw" "uid=1000" "gid=1000" "x-systemd.automount" "noauto" ];
    };
  };

  swapDevices = [ /*{ device = "/swap"; size = 1024 * 8; options = [ "mode=600"]; }*/ ];

  environment.persistence = {
    "/nix/persist" = {
      hideMounts = true;
      directories = [
        "/etc/nixos"
        "/media"
        "/mounts"
        "/root"
        "/srv"
        "/var/lib"
        "/var/log"
      ];
    };
    "/home/binette/.local/share" = {
      hideMounts = true;
      directories = [
        { directory = "/opt"; user = "binette"; group = "binette"; mode = "u=rwx,g=rx,o="; }
      ];
    };
  };

  /* ---Network--- */
  networking = {
    hostName = "desktop-server";
    interfaces = {
      tailscale0.useDHCP = true;
      enp34s0 = {
#        name = "eth0";
        useDHCP = true;
      };
      wlo1 = {
        useDHCP = true;
#        name = "wlan0";
#        ipv4.addresses = [{
#          address = "192.168.1.2";
#          prefixLength = 24;
#        }];
      };
#      "br0" = {
#        name = "br0";
#        ipv4.addresses = [{
#          address = "192.168.1.4";
#          prefixLength = 24;
#        }];
#      };
    };
#    bridges."br0".interfaces = [ "wlo1" ];

    nat = {
      enable = true;
#      internalInterfaces = [ "ve-+" ];
#      externalInterface = "br0";
    };
  };
#  services.resolved.enable = true;

  /* ---CPU Stuff--- */
  powerManagement.cpuFreqGovernor = lib.mkDefault "conservative";
  nix.settings.max-jobs = 16;
}
