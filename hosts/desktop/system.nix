{ pkgs, system, config, lib, inputs, modulesPath, ... }: {

  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    ../../modules/system/default.nix
  ];

  ## Custom modules ##
  modules = {
    bootloader = "grub";
    windowManager = "dwm";
    transmission.enable = true;
    services = {
      greenclip.enable = true;
      tty-login-prompt.enable = true;
    };
    profiles = {
      gaming.enable = true;
      core = {
        enable = true;
        bluetooth.enable = true;
        wifi.enable = true;
        print.enable = true;
        ssd.enable = true;
        virtmanager.enable = false;
        impermanence.enable = true;
      };
    };
  };

  ## hardware ##
    # GPU
  services.xserver.videoDrivers = [ "nvidia" ];
    # CPU
  nix.settings.max-jobs = 16; # ryzen 7 5800x
  hardware.cpu.amd.updateMicrocode = true;

  ## Networking ##
  networking = {
    hostName = "desktop";
    interfaces.wlo1.useDHCP = true;
    interfaces.tailscale0.useDHCP = true;
    wireless = {
      interfaces = [ "wlo1" ];
    };
  };

  ## Kernel modules/packages ##
  boot = {
    extraModulePackages = [ ];
    kernelModules = [ "kvm-amd" "nvidia" ];
    kernelPackages =  pkgs.linuxPackages_xanmod;
    kernelParams = [ ];
    initrd = {
      availableKernelModules = [ "xhci_pci" "ahci" "usbhid" "usb_storage" "sd_mod" ];
      kernelModules = [ ];
    };
  };

  ## FileSystem ##
  fileSystems = {
    "/nix/persist/home" = {
      device = "/dev/disk/by-label/home";
      fsType = "ext4";
    };
    "/mounts/nas" = {
      device = "100.110.26.48:/media";
#      device = "100.71.254.90:/media";
      fsType = "nfs";
        # don't freeze system if mount point not available on boot
      options = [ "x-systemd.automount" "noauto" ];
    };
  };
  swapDevices = [ ];

  environment.persistence."/nix/persist" = {
    hideMounts = true;
    directories = [
      "/mounts"
    ];
  };

  ## Performance stuff ##
  powerManagement.cpuFreqGovernor = "conservative";
  programs.gamemode.enable = true;

  ## Screen resolution ##
  services.xserver = {
    xrandrHeads = [{
      output = "DisplayPort-0";
      primary = true;
      monitorConfig = ''
          # 2560x1440 164.90 Hz (CVT) hsync: 261.86 kHz; pclk: 938.50 MHz
        Modeline "2560x1440_165.00"  938.50  2560 2792 3072 3584  1440 1443 1448 1588 -hsync +vsync
        Option "PreferredMode" "2560x1440_165.00"
        Option "Position" "0 0"
      '';
    }];
  };

  nixpkgs.config.allowUnfree = true;

}
