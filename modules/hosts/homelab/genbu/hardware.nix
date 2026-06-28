{ inputs, ... }:
{
  flake.nixosModules.genbu =
    {
      lib,
      modulesPath,
      pkgs,
      ...
    }:
    {
      # ---Imports---
      imports = [
        #(flake.inputs.nixos-hardware + "/raspberry-pi/4")
        (modulesPath + "/installer/scan/not-detected.nix")
        inputs.nixos-hardware.nixosModules.raspberry-pi-4
      ];

      # ---kernel modules/packages---
      boot = {
        kernelPackages = pkgs.linuxPackages_rpi4;
        initrd.availableKernelModules = [
          "xhci_pci"
          "usbhid"
          "usb_storage"
        ];
        # ttyAMA0 is the serial console broken out to the GPIO
        kernelParams = [
          "8250.nr_uarts=1"
          "console=ttyAMA0,115200"
          "console=tty1"
          "cma=128M" # Some gui programs need this
        ];
      };

      # ---FileSystem---
      fileSystems = {
        "/" = {
          device = "/dev/disk/by-label/NIXOS_SD";
          fsType = "ext4";
        };
        "/data" = {
          device = "/dev/disk/by-label/data01";
          fsType = "ext4";
          options = [
            "nofail"
            "x-systemd.automount"
            "x-systemd.device-timout=5s"
          ];
        };
      };
      swapDevices = [
        {
          device = "/swapFile";
          size = 1024 * 8;
        }
      ];

      # ---Networking---
      networking = {
        interfaces.eth0.useDHCP = true;
        interfaces.wlan0.useDHCP = true;
        wireless.interfaces = [ "wlan0" ];
        #defaultGateway = "192.168.18.1";
        #nameservers = [ "192.168.18.1" ];
      };

      nix.settings.max-jobs = 4;
      hardware.raspberry-pi."4".fkms-3d.enable = true;
      boot.tmp.useTmpfs = lib.mkForce false;
      powerManagement.cpuFreqGovernor = lib.mkForce "conservative";
    };
}
