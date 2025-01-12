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
      device = "/dev/disk/by-uuid/624c5da1-186b-45b5-a251-aee85e877e8c";
      fsType = "ext4";
    };
    "/boot" = { 
      device = "/dev/disk/by-uuid/08A8-B7DF";
      fsType = "vfat";
      options = [ "fmask=0077" "dmask=0077" ];
    };
      #Temporary fileSystem
    "/mnt/games" = {
      device = "/dev/disk/by-uuid/6d183b34-2f6d-4dab-a1af-6bbcdb16bd2c";
      fsType = "ext4";
    };
  };
  swapDevices = [ ];

  /* ---Networking--- */
  networking = {
    hostName = "decky";
    useDHCP = lib.mkForce true;
    wireless.enable = lib.mkForce false;
    networkmanager.enable = lib.mkForce true;
  };

  /* ---CPU Stuff--- */
    # Dont know yet what the default value is.
  #powerManagement.cpuFreqGorvernor = lib.mkDefault "performance";
  nix.settings.max-jobs = 8; # CPU Treads
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

  #nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

}
