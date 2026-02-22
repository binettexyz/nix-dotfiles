{
  flake.nixosModules.ouryuu =
    {
      lib,
      modulesPath,
      pkgs,
      ...
    }:
    {
      # ---Imports---
      imports = [
        (modulesPath + "/installer/scan/not-detected.nix")
      ];

      # ---kernel modules/packages---
      boot = {
        kernelPackages = pkgs.linuxPackages_latest;
        initrd.availableKernelModules = [
          "xhci_pci"
          "ahci"
          "usbhid"
          "usb_storage"
          "sd_mod"
        ];
        initrd.kernelModules = [ "dm-snapshot" ];
        kernelModules = [ "kvm-intel" ];
        extraModulePackages = [ ];
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
          options = [
            "fmask=0022"
            "dmask=0022"
          ];
        };
        "/home/data" = {
          device = "/dev/disk/by-label/data01";
          fsType = "ext4";
          options = [
            "nofail"
            "x-systemd.automount"
            "x-systemd.device-timout=5s"
          ];
        };
        "/nix" = {
          device = "/dev/disk/by-label/nix";
          fsType = "ext4";
        };
      };

      swapDevices = [ { device = "/dev/disk/by-label/swap"; } ];

      environment.persistence."/nix/persist" = {
        hideMounts = true;
        directories = [
          "/home"
        ];
      };

      # ---Networking---
      networking = {
        interfaces.eno1.ipv4.addresses = [
          {
            address = "192.168.18.15";
            prefixLength = 24;
          }
        ];
        defaultGateway = {
          address = "192.168.18.1";
          interface = "eno1";
        };
      };

      nix.settings.max-jobs = 6;
      powerManagement.cpuFreqGovernor = lib.mkForce "conservative";
    };
}
