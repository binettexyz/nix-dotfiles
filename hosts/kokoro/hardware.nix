{ config, flake, lib, modulesPath, pkgs, system, ... }:

{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    #flake.inputs.hardware.nixosModules.common-cpu-intel
  ];


  /* ---Kernel Stuff--- */
  boot = {
      # acpi_call makes tlp work for newer thinkpads
    extraModulePackages = with config.boot.kernelPackages; [ acpi_call ];
    kernelModules = [ "kvm-intel" ];
    kernelPackages = pkgs.linuxPackages_latest;
    kernelParams = [];
    initrd = {
      availableKernelModules = [ "xhci_pci" "ehci_pci" "ahci" "usbhid" "usb_storage" "sr_mod" "sd_mod" "rtsx_pci_sdmmc" ];
      kernelModules = [ "i915" "acpi_call" ];
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
    "/nix/persist/home" = {
      device = "/dev/disk/by-label/home";
      fsType = "ext4";
    };
    "/nix" = {
      device = "/dev/disk/by-label/nix";
      fsType = "ext4";
    };
    "/mounts/nas" = {
      device = "100.71.254.90:/media";
      fsType = "nfs";
        # don't freeze system if mount point not available on boot
      options = [ "x-systemd.automount" "noauto" ];
    };
  };
  swapDevices = [{ device = "/dev/disk/by-label/swap"; }];

  environment.persistence."/nix/persist" = {
    hideMounts = true;
    directories = [
      "/etc/nixos"
      "/var/lib"
      "/var/log"
#      "/home"
      "/root"
      "/srv"
    ];
  };


  /* ---Graphic Card--- */ 
  services.xserver.videoDrivers = [ "modesetting" ];
  hardware.enableRedistributableFirmware = true;
  hardware.graphics.extraPackages = with pkgs; [
    vaapiIntel
    vaapiVdpau
    libvdpau-va-gl
    intel-media-driver
  ];


  /* ---Network--- */
  networking = {
    hostName = "kokoro";
    interfaces.wlp3s0.useDHCP = true;
    interfaces.enp0s25.useDHCP = true;
    wireless = {
      interfaces =  [ "wlp3s0" ];
    };
  };


  /* ---Touchpad & Trackpoint--- */
    # Touchpad
  services.libinput = {
    enable = true;
    touchpad = {
      naturalScrolling = true;
      tapping = true;
      disableWhileTyping = true;
      middleEmulation = true;
    };
    mouse = {
      accelProfile = lib.mkForce "flat";
      #accelSpeed = "1";
    };
  };

    # Trackpoint
  hardware.trackpoint = {
    enable = true;
    sensitivity = 300;
    speed = 100;
    emulateWheel = false;
  };


  /* ---CPU Stuff--- */
  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
  nix.settings.max-jobs = 4; # CPU Treads
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
  services.throttled.enable = true;
}
