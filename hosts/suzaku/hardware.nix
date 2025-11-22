{
  config,
  flake,
  lib,
  modulesPath,
  pkgs,
  ...
}:
{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    # Enable the amd cpu scaling. Can be more energy efficient on recent AMD CPUs.
    flake.inputs.nixos-hardware.nixosModules.common-cpu-amd-pstate
  ];

  boot = {
    extraModulePackages = [ ];
    kernelModules = [ "kvm-amd" ];
    kernelPackages = lib.mkDefault pkgs.linuxPackages_xanmod;
    kernelParams = [
      "mitigations=off"
      "nowatchdog"
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
      kernelModules = [ "amdgpu" ];
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
      device = "/dev/disk/by-label/nixos";
      fsType = "ext4";
    };
    #    "/home" = {
    #      device = "/dev/disk/by-label/home";
    #      fsType = "ext4";
    #    };
    "/home/games/ssd" = {
      device = "/dev/disk/by-label/ssdGames";
      fsType = "ext4";
    };
    #    "/home/games/hdd" = {
    #      device = "/dev/disk/by-label/hddGames";
    #      fsType = "ext4";
    #    };
    "/tmp" = {
      device = "/home/binette/.cache/tmp";
      options = [ "bind" ];
    };
    "/home/homelab" = {
      device = "100.110.153.50:/data";
      fsType = "nfs";
      # don't freeze system if mount point not available on boot
      options = [
        "x-systemd.automount"
        "noauto"
      ];
    };
  };

  swapDevices = [
    # { device = "/swap"; size = 1024 * 8; options = [ "mode=600"]; }
    { device = "/dev/disk/by-label/swap"; }
  ];

  environment.persistence = {
    "/nix/persist" = {
      hideMounts = true;
      directories = [
        "/etc/NetworkManager"
        "/etc/nixos"
        "/var/lib"
        "/var/log"
        "/root"
        "/home"
      ];
    };
  };

  # ---Networking---
  networking = {
    useDHCP = lib.mkForce false;
    interfaces.wlo1.useDHCP = true;
    intrfaces.enp34s0.useDHCP = true;
    wireless.enable = lib.mkForce false;
    networkmanager.enable = lib.mkForce true;
  };

  # ---Bluetooth---
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };
  services.blueman.enable = true;

  # ---Video Driver---
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };
  #FIXME: Break gamescope
  #  hardware.amdgpu = {
  #    initrd.enable = true;
  #    amdvlk = {
  #      enable = true;
  #      support32Bit.enable = true;
  #    };
  #  };

  # ---Processor---
  powerManagement.cpuFreqGovernor = lib.mkDefault "performance";
  nix.settings.max-jobs = 16; # CPU Treads
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
