{
  config,
  flake,
  lib,
  modulesPath,
  pkgs,
  ...
}: {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    # Enable the amd cpu scaling. Can be more energy efficient on recent AMD CPUs.
    flake.inputs.nixos-hardware.nixosModules.common-cpu-amd-pstate
  ];

  boot = {
    extraModulePackages = [];
    kernelModules = ["kvm-amd"];
    kernelPackages = pkgs.linuxPackages_xanmod;
    kernelParams = [
      "mitigations=off"
      "nowatchdog"
      "video=HDMI-A-1:1920x1080@179.981955"
      "video=HDMI-A-2:3840x2160@120"
    ];
    kernel.sysctl."kernel.nmi_watchdog" = 0; # Disable watchdog. Use with "nowatchdog" in kernelParams.
    initrd = {
      availableKernelModules = [
        "xhci_pci"
        "ahci" # "nvme"
        "usbhid"
        "usb_storage"
        "sd_mod"
      ];
      kernelModules = [];
    };
  };

  # ---FileSystem---
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
    };
    "/nix" = {
      device = "/dev/disk/by-label/nix";
      fsType = "ext4";
    };
    "/home" = {
      device = "/dev/disk/by-label/home";
      fsType = "ext4";
    };
    "/home/games/ssd" = {
      device = "/dev/disk/by-label/ssdGames";
      fsType = "ext4";
    };
    "/home/games/hdd" = {
      device = "/dev/disk/by-label/hddGames";
      fsType = "ext4";
    };
#    "/tmp" = {
#      device = "/home/binette/.cache/tmp";
#      options = ["bind"];
#    };
#    "/home/homelab" = {
#      device = "100.110.153.50:/data";
#      fsType = "nfs";
#      # don't freeze system if mount point not available on boot
#      options = ["x-systemd.automount" "noauto"];
#    };
  };

  swapDevices = [
    # { device = "/swap"; size = 1024 * 8; options = [ "mode=600"]; }
    { device = "/dev/disk/by-label/swap"; }
  ];

  environment.persistence = {
    "/nix/persist" = {
      hideMounts = true;
      directories = [
        "/etc/nixos"
        "/var/lib"
        "/var/log"
        "/root"
      ];
    };
  };

  # ---Networking---
  networking = {
    hostName = "seiryu";
    useDHCP = lib.mkForce false;
  };

  # ---Bluetooth---
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };
  services.blueman.enable = true;

  # ---Video Driver---
  hardware = {
    # Enable loading amdgpu kernelModule in stage 1.
    # Can fix lower resolution in boot screen during initramfs phase
    amdgpu.initrd.enable = true;
    graphics.enable = true;
    graphics.enable32Bit = true;
    graphics.extraPackages = [pkgs.amdvlk];
    graphics.extraPackages32 = [pkgs.driversi686Linux.amdvlk];
  };

  # ---Processor---
  #powerManagement.cpuFreqGorvernor = lib.mkDefault "performance";
  nix.settings.max-jobs = 16; # CPU Treads
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
