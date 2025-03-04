{ config, flake, lib, modulesPath, pkgs, ... }:

let
  inherit (flake) inputs;
in {

  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
      # Enable the amd cpu scaling. Can be more energy efficient on recent AMD CPUs.
    flake.inputs.nixos-hardware.nixosModules.common-cpu-amd-pstate
  ];

  boot = {
    extraModulePackages = [ ];
    kernelModules = [ "kvm-amd" ];
    kernelPackages =  pkgs.linuxPackages_xanmod;
    kernelParams = [ "mitigations=off" ];
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
    "/home/games/ssd" = {
      device = "/dev/disk/by-label/ssdGames";
      fsType = "ext4";
    };
    "/home/games/hdd" = {
      device = "/dev/disk/by-label/hddGames";
      fsType = "ext4";
    };
#    "/mounts/nas" = {
#      device = "100.71.254.90:/media";
#      fsType = "nfs";
        # don't freeze system if mount point not available on boot
#      options = [ "x-systemd.automount" "noauto" ];
#    };
  };

  swapDevices = [ /*{ device = "/swap"; size = 1024 * 8; options = [ "mode=600"]; }*/ ];

  environment.persistence = {
    "/nix/persist" = {
      hideMounts = true;
      directories = [
        "/etc/NetworkManager"
        "/etc/nixos"
        "/var/lib"
        "/var/log"
        "/root"
        "/srv"
      ];
    };
  };

  /* ---Networking--- */
  networking = {
    hostName = "seiryu";
    useDHCP = lib.mkForce false;
    wireless.enable = lib.mkForce false;
    networkmanager.enable = lib.mkForce true;
  };

  /* ---Bluetooth--- */
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };

  /* ---Video Driver--- */
  services.xserver.videoDrivers = lib.mkForce [ "amdgpu" ];
    # Enable loading amdgpu kernelModule in stage 1.
    # Can fix lower resolution in boot screen during initramfs phase
  hardware.amdgpu.initrd.enable = true;
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  /* ---Processor--- */
  #powerManagement.cpuFreqGorvernor = lib.mkDefault "performance";
  nix.settings.max-jobs = 16; # CPU Treads
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

}
