{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [ (modulesPath + "/installer/scan/not-detected.nix")
    ];

  boot.initrd.availableKernelModules = [ "xhci_pci" "nvme" "usb_storage" "sd_mod" ];
  boot.initrd.kernelModules = [ "dm-snapshot" ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" =
    { device = "none";
      fsType = "tmpfs";
      options = [
        "defaults"
        "size=2G"
        "mode=755"
      ];
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-label/boot";
      fsType = "vfat";
      options = [ "fmask=0022" "dmask=0022" ];
    };

  fileSystems."/nix" =
    { device = "/dev/disk/by-label/nix";
      fsType = "ext4";
    };

  fileSystems."/home" =
    { device = "/dev/disk/by-label/home";
      fsType = "ext4";
    };

  swapDevices = [ {device = "/dev/disk/by-label/swap";} ];

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
  services.xserver.videoDrivers = [ "modesetting" ];
  hardware.enableRedistributableFirmware = true;
  hardware.graphics.extraPackages = with pkgs; [
    vaapiIntel
    vaapiVdpau
    libvdpau-va-gl
    intel-media-driver
  ];

  networking = {
    hostName = "hayate";
    interfaces.enp0s31f6.useDHCP = true;
    interfaces.wlp3s0.useDHCP = true;
    wireless.interfaces = [ "wlp3s0" ];
  };

 # Trackpoint
  hardware.trackpoint = {
    enable = true;
    sensitivity = 300;
    speed = 100;
    emulateWheel = false;
  };

  # ---CPU Stuff---
  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
  nix.settings.max-jobs = 8; # CPU Treads
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
  services.throttled.enable = true;

}
