{ config, flake, lib, modulesPath, pkgs, ... }:

let
  inherit (flake) inputs;
in {

  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    flake.inputs.nixos-hardware.nixosModules.common-cpu-amd
    flake.inputs.nixos-hardware.nixosModules.common-cpu-amd-pstate
    flake.inputs.nixos-hardware.nixosModules.common-gpu-nvidia-nonprime
  ];

  boot = {
    extraModulePackages = [ ];
    kernelModules = [ "kvm-amd" "nvidia" ];
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
    "/nix/persist/home" = {
      device = "/dev/disk/by-label/home";
      fsType = "ext4";
    };
    "/mounts/nas" = {
      device = "100.71.254.90:/media";
      fsType = "nfs";
        # don't freeze system if mount point not available on boot
      options = [ "x-systemd.automount" "noauto" ];
    };
  };

  swapDevices = [ /*{ device = "/swap"; size = 1024 * 8; options = [ "mode=600"]; }*/ ];

  environment.persistence = {
    "/nix/persist" = {
      hideMounts = true;
      directories = [
        "/etc/nixos"
        "/var/lib"
        "/var/log"
        "/mounts"
        "/root"
        "/srv"
      ];
    };
    "/nix/persist/home/binette/.local/share" = {
      hideMounts = true;
      directories = [
        "/opt"
      ];
    };
  };

  /* ---Screen resolution--- */
  services.xserver = {
    xrandrHeads = [{
      output = "DP-2";
      primary = true;
      monitorConfig = ''
          # 2560x1440 164.90 Hz (CVT) hsync: 261.86 kHz; pclk: 938.50 MHz
        Modeline "2560x1440_165.00"  938.50  2560 2792 3072 3584  1440 1443 1448 1588 -hsync +vsync
        Option "PreferredMode" "2560x1440_165.00"
        Option "Position" "0 0"
      '';
    }];
  };

  powerManagement.cpuFreqGovernor = lib.mkDefault "conservative";
}
