{
  config,
  flake,
  lib,
  pkgs,
  modulesPath,
  ...
}: {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    flake.inputs.nixos-hardware.nixosModules.lenovo-thinkpad-t480
  ];

  boot = {
    kernelModules = ["kvm-intel"];
    extraModulePackages = [];
    kernelPackages = pkgs.linuxPackages_latest;
    kernelParams = [];
    extraModprobeConfig = "options thinkpad_acpi fan_control=1";
    initrd = {
      availableKernelModules = [
        "xhci_pci"
        "nvme"
        "usb_storage"
        "sd_mod"
      ];
      kernelModules = ["dm-snapshot"];
      luks.devices = {
        crypted.device = "/dev/disk/by-uuid/5c4d86fb-32ef-4aae-8e1e-7bc5a8dcc2bc";
        crypted.preLVM = true;
      };
    };
  };

  fileSystems = {
    "/" = {
      device = "none";
      fsType = "tmpfs";
      options = [
        "defaults"
        "size=2G"
        "mode=755"
      ];
    };
    "/boot" = {
      device = "/dev/disk/by-label/boot";
      fsType = "vfat";
      options = ["fmask=0022" "dmask=0022"];
    };
    "/nix" = {
      device = "/dev/disk/by-label/nix";
      fsType = "ext4";
    };
    "/home" = {
      device = "/dev/disk/by-label/home";
      fsType = "ext4";
    };
    "/home/homelab" = {
      device = "100.110.153.50:/data";
      fsType = "nfs";
      options = ["x-systemd.automount" "noauto"];
    };
  };

  swapDevices = [{device = "/dev/disk/by-label/swap";}];

  environment.persistence."/nix/persist" = {
    hideMounts = true;
    directories = [
      "/etc/nixos"
      "/var/lib"
      "/var/log"
      "/root"
      "/srv"
    ];
  };

  # ---Graphic Card---
  services.xserver.videoDrivers = ["modesetting"];
  hardware.enableRedistributableFirmware = true;
  hardware.graphics.extraPackages = [
    pkgs.vaapiIntel
    pkgs.vaapiVdpau
    pkgs.libvdpau-va-gl
    pkgs.intel-media-driver
  ];

  networking = {
    hostName = "hayate";
    interfaces.enp0s31f6.useDHCP = true;
    interfaces.wlp3s0.useDHCP = true;
    wireless.interfaces = ["wlp3s0"];
  };

  # Trackpoint
  hardware.trackpoint = {
    enable = true;
    sensitivity = 300;
    speed = 100;
    emulateWheel = false;
  };

  # ---CPU Stuff---
  nix.settings.max-jobs = 8; # CPU Treads
}
