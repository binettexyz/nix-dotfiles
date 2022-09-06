{ pkgs, system, config, inputs, lib, modulesPath, ... }: {

  imports = [
    (inputs.nixos-hardware + "/raspberry-pi/4")
    (modulesPath + "/installer/scan/not-detected.nix")
    ../../modules/system/default.nix
  ];

  ## Custom modules ##
  modules = {
    bootloader = "rpi4";
    services = {
      tty-login-prompt.enable = true;
    };
    profiles = {
      core = {
        enable = true;
        bluetooth.enable = false;
        wifi.enable = true;
        print.enable = false;
        ssd.enable = false;
        virtmanager.enable = false;
        impermanence.enable = true;
      };
    };
  };

  ## Hardware ##
  nix.settings.max-jobs = 4;
    # with gpu
  hardware.raspberry-pi."4".fkms-3d.enable = true;
    # without gpu
#  services.xserver.videoDrivers = [ "fbdev" ];

  ## Networking ##
  networking = {
    hostName = "rpi4";
    interfaces.eth0.useDHCP = true;
    interfaces.wlan0.useDHCP = true;
    wireless.interfaces = [ "wlan0" ];
  };

    # kernel modules/packages
  boot = {
    kernelPackages = pkgs.linuxPackages_rpi4;
    initrd.availableKernelModules = [ "xhci_pci" "usbhid" "usb_storage" ];
      # ttyAMA0 is the serial console broken out to the GPIO
    kernelParams = [
      "8250.nr_uarts=1"
      "console=ttyAMA0,115200"
      "console=tty1"
      "cma=128M" # Some gui programs need this
    ];
  };

  ## FileSystem ##
  swapDevices = [{ device = "/dev/disk/by-label/swap"; }];

  ## Performance stuff ##
  powerManagement.cpuFreqGovernor = lib.mkForce "powersaver";

  ##  Impermanence ##
  environment.persistence."/nix/persist" = {
    directories = [ "/home" ];
  };

}

