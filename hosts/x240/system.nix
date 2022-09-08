{ pkgs, system, config, lib, modulesPath, ... }: {

  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    ../../modules/system/default.nix
  ];

  ## Custom modules ##
  modules = {
    bootloader = "grub";
    windowManager = "dwm";
    services = {
      greenclip.enable = true;
      tty-login-prompt.enable = true;
    };
    profiles = {
      laptop.enable = true;
      server.enable = true;
      core = {
        enable = true;
        bluetooth.enable = true;
        wifi.enable = false;
        print.enable = true;
        ssd.enable = true;
        virtmanager.enable = false;
        impermanence.enable = true;
      };
    };
  };

  ## Hardware ##
    # IGPU
  services.xserver.videoDrivers = [ "intel" ];
  hardware.enableRedistributableFirmware = true;
  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
    extraPackages = with pkgs; [
      vaapiIntel
      vaapiVdpau
      libvdpau-va-gl
      intel-media-driver
    ];
  };

    # CPU
  nix.settings.max-jobs = 4;
  hardware.cpu.intel.updateMicrocode = true;
  services.throttled.enable = false;

    # Trackpad
  services.xserver.libinput.enable = true;
  services.xserver.libinput.touchpad = {
    naturalScrolling = true;
    tapping = true;
    disableWhileTyping = true;
    middleEmulation = true;
  };

    # Trackpoint
  hardware.trackpoint = {
    enable = true;
    sensitivity = 300;
    speed = 100;
    emulateWheel = false;
  };

  ## Networking ##
  networking = {
    hostName = "x240";
    interfaces.wlan0.useDHCP = true;
    interfaces.enp0s25.useDHCP = true;
    wireless = {
      interfaces =  [ "wlan0" ];
    };
  };

  ## Kernel modules/packages ##
  boot = {
      # acpi_call makes tlp work for newer thinkpads
    extraModulePackages = with config.boot.kernelPackages; [ acpi_call ];
    kernelModules = [ "kvm-intel" ];
    kernelPackages = pkgs.linuxPackages_latest;
    kernelParams = [];
    initrd = {
      availableKernelModules = [ "xhci_pci" "ehci_pci" "ahci" "usbhid" "usb_storage" "uas" "sd_mod" "rtsx_pci_sdmmc" ];
      kernelModules = [ "i915" "acpi_call" ];
    };
  };
  
  ## FileSystem ##
  fileSystems = {
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
  swapDevices = [{ device = "/dev/disk/by-uuid/a0c6bce5-ed75-4258-824a-0b08941e4100"; }];

  environment.persistence."/nix/persist" = {
    hideMounts = true;
    directories = [
      "/mounts"
    ];
  };

  ## Performance stuff ##
  powerManagement.cpuFreqGovernor = "powersave";

  ## Screen resolution ##
  services.xserver = {
    xrandrHeads = [
      {
        output = "eDP1";
        primary = true;
        monitorConfig = ''
          Modeline "1368x768_60.11"   85.50  1368 1440 1576 1784  768 771 781 798 -hsync +vsync
          Option "PreferredMode" "1366x768_60.11"
          Option "Position" "0 0"
          DisplaySize 276 156
        '';
      }
    ];
  };

  nixpkgs.config.allowUnfree = true;

}
