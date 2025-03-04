{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  /* ---Kernel Stuff--- */
  boot = {
    #kernelPackages = ;
    kernelModules = [ "kvm-amd" ];
    kernelParams = [ "mitigations=off" ];
    extraModulePackages = [ ];
    initrd = {
      availableKernelModules = [ "nvme" "xhci_pci" "usbhid" "usb_storage" "sd_mod" "sdhci_pci" ];
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
      options = [ "fmask=0077" "dmask=0077" ];
    };
      #Temporary fileSystem
    "/home" = {
      device = "/dev/disk/by-label/home";
      fsType = "ext4";
    };
    "/nix" = {
      device = "/dev/disk/by-label/nix";
      fsType = "ext4";
    };
  };
  swapDevices = [ ];

  environment.persistence."/nix/persist" = {
    hideMounts  = true;
    directories = [
      "/etc/NetworkManager"
      "/etc/nixos"
      "/var/log"
      "/var/lib"
      "/root"
      "/srv"
    ];
  };

  /* ---Networking--- */
  networking = {
    hostName = "gyorai";
    useDHCP = lib.mkForce true;
    wireless.enable = lib.mkForce false;
    networkmanager.enable = lib.mkForce true;
  };

  /* ---Bluetooth--- */
  # Enable experimental settings or else theres no bluetooth on boot.
  # https://discourse.nixos.org/t/bluetooth-not-working/27812
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings = {
      General = {
        Name = "gyorai";
        ControllerMode = "dual";
        Experimental = "true";
      };
      Policy = {
        AutoEnable = "true";
      };
    };
  };

  hardware.enableAllFirmware = true;

  /* ---CPU Stuff--- */
    # Dont know yet what the default value is.
  #powerManagement.cpuFreqGorvernor = lib.mkDefault "performance";
  nix.settings.max-jobs = 8; # CPU Treads
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

  #nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

}
