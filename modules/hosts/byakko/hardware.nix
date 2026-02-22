{ inputs, ... }:
{
  flake.nixosModules.byakko =
    {
      pkgs,
      modulesPath,
      ...
    }:
    {
      imports = [
        (modulesPath + "/installer/scan/not-detected.nix")
        inputs.nixos-hardware.nixosModules.lenovo-thinkpad-t480
      ];

      boot = {
        kernelModules = [ "kvm-intel" ];
        extraModulePackages = [ ];
        kernelPackages = pkgs.linuxPackages_latest;
        kernelParams = [ ];
        extraModprobeConfig = "options thinkpad_acpi fan_control=1";
        initrd = {
          availableKernelModules = [
            "xhci_pci"
            "nvme"
            "usb_storage"
            "sd_mod"
          ];
          kernelModules = [ "dm-snapshot" ];
          luks.devices = {
            crypted.device = "/dev/disk/by-uuid/9d0436d8-56ee-4b0b-b364-b97a699cc4a6";
            crypted.preLVM = true;
          };
        };
      };

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

        "/nix" = {
          device = "/dev/disk/by-label/nix";
          fsType = "ext4";
        };

        "/boot" = {
          device = "/dev/disk/by-label/boot";
          fsType = "vfat";
          options = [
            "fmask=0022"
            "dmask=0022"
          ];
        };

        "/home/homelab" = {
          device = "100.127.182.62:/home/data";
          fsType = "nfs";
          options = [
            "x-systemd.automount"
            "noauto"
          ];
        };
      };

      swapDevices = [ { device = "/dev/disk/by-label/swap"; } ];

      environment.persistence."/nix/persist" = {
        hideMounts = true;
        directories = [
          "/home"
        ];
      };

      # ---Graphic Card---
      services.xserver.videoDrivers = [ "modesetting" ];
      hardware.enableRedistributableFirmware = true;

      networking = {
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
      nix.settings.max-jobs = 8; # CPU Treads
    };
}
