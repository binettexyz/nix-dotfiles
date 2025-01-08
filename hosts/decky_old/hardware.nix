{ config, flake, lib, modulesPath, pkgs, ... }:

let
  inherit (flake) inputs;
in {

  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    #flake.inputs.nixos-hardware.nixosModules.common-cpu-amd
  ];

  boot = {
    extraModulePackages = [ ];
    kernelModules = [ "kvm-amd" ];
    kernelParams = [ ];
    initrd = {
      availableKernelModules = [ "nvme" "xhci_pci" "usbhid" "uas" "sd_mod" "sdhci_pci" ];
      kernelModules = [ ];
    };
  };

  /* ---FileSystem--- */
  fileSystems = {
    "/" = {
      device = "/dev/disk/by-label/nixos";
      fsType = "ext4";
    };
    "/boot" = {
      device = "/dev/disk/by-label/boot";
      fsType = "vfat";
    };
#    "/sdcard" = {
#      device = "/dev/disk/by-label/---";
#      fsType = "ext4";
#      # It's okay if it's missing, automounted on access
#      options = [ "nofail" "x-systemd.automount" ];
#    };
  };

  swapDevices = [ /*{ device = "/swap"; size = 1024 * 8; options = [ "mode=600"]; }*/ ];

  /* ---Screen resolution--- */
#  services.xserver = {
#    xrandrHeads = [{
#      output = "default";
#      primary = true;
#      monitorConfig = ''
#          # 1280x800 59.81 Hz (CVT 1.02MA) hsync: 49.70 kHz; pclk: 83.50 MHz
#        Modeline "1280x800_60.00"   83.50  1280 1352 1480 1680  800 803 809 831 -hsync +vsync
#        Option "PreferredMode" "1280x800_60.00"
#        Option "Position" "0 0"
#      '';
#    }];
#  };

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

#  powerManagement.cpuFreqGovernor = lib.mkDefault "conservative";

}
