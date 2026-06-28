{
  flake.nixosModules.kei =
    {
      config,
      lib,
      modulesPath,
      ...
    }:
    {
      imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

      boot.initrd.availableKernelModules = [
        "xhci_pci"
        "ehci_pci"
        "ahci"
        "sd_mod"
        "sr_mod"
      ];
      boot.initrd.kernelModules = [ "dm-snapshot" ];
      boot.kernelModules = [ ];
      boot.extraModulePackages = [ ];
      boot.kernel.sysctl = {
        "vm.swappiness" = 10;
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
      };

      swapDevices = [ { device = "/dev/disk/by-label/swap"; } ];

      # ---Graphic Card---
      services.xserver.videoDrivers = [ "modesetting" ];

      # ---Network---
      networking = {
        interfaces.wlp3s0.useDHCP = true;
        interfaces.enp0s25.useDHCP = true;
        wireless = {
          interfaces = [ "wlp3s0" ];
        };
      };

      # ---Touchpad & Trackpoint---
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

      # ---CPU Stuff---
      powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
      nix.settings.max-jobs = 4; # CPU Treads
      services.throttled.enable = true;
    };
}
