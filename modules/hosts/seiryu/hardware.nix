{
  flake.nixosModules.seiryu =
    {
      lib,
      pkgs,
      modulesPath,
      ...
    }:
    {
      imports = [
        (modulesPath + "/installer/scan/not-detected.nix")
      ];

      # ---Kernel Stuff---
      boot = {
        kernelModules = [ "kvm-amd" ];
        kernelParams = [
          "splash" # Needed for plymouth
          "mitigations=off"
          "nowatchdog"
        ];
        kernel.sysctl."kernel.nmi_watchdog" = 0; # Disable watchdog. Use with "nowatchdog" in kernelParams.
        extraModulePackages = [ ];
        initrd = {
          availableKernelModules = [
            "nvme"
            "xhci_pci"
            "usbhid"
            "usb_storage"
            "sd_mod"
            "sdhci_pci"
          ];
          kernelModules = [ ];
        };
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

        "/home" = {
          device = "/dev/disk/by-label/home";
          fsType = "ext4";
        };
      };

      environment.persistence."/nix/persist" = {
        hideMounts = true;
        directories = [
          "/etc/NetworkManager"
        ];
      };

      # ---Networking---
      networking.interfaces.wlo1.useDHCP = true;

      # ---CPU Stuff---
      # Dont know yet what the default value is.
      #powerManagement.cpuFreqGorvernor = lib.mkDefault "performance";
      nix.settings.max-jobs = 8; # CPU Treads
    };
}
