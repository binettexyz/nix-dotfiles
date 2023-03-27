{ config, flake, lib, modulesPath, pkgs, system, ... }:

{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    #inputs.hardware.nixosModules.common-cpu-intel
  ];

  boot = {
      # acpi_call makes tlp work for newer thinkpads
    extraModulePackages = with config.boot.kernelPackages; [ acpi_call ];
    kernelModules = [ "kvm-intel" ];
    kernelPackages = pkgs.linuxPackages_latest;
    kernelParams = [ "mitigations=off" ];
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

  environment.persistence = {
    "/nix/persist" = {
      hideMounts = true;
      directories = [
        "/etc/nixos"
        "/var/lib"
        "/var/log"
#        "/home"
        "/root"
        "/srv"
      ];
    };
  };

  ## Screen resolution ##
  services.xserver.xrandrHeads = [{
    output = "eDP1";
    primary = true;
    monitorConfig = ''
      Modeline "1366x768_60.00"   85.25  1368 1440 1576 1784  768 771 781 798 -hsync +vsync
      Option "PreferredMode" "1366x768_60.00"
      Option "Position" "0 0"
    '';
      #DisplaySize 276 156
  }];

  services.xserver.libinput = {
    enable = true;
    touchpad = {
      naturalScrolling = true;
      tapping = true;
      disableWhileTyping = true;
      middleEmulation = true;
    };
    mouse = {
      accelProfile = "flat";
      #accelSpeed = "1";
    };
  };

  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
}
