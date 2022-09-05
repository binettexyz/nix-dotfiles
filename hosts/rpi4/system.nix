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
      server.enable = true;
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
    containers = {
      bazarr.enable = true;
      deluge.enable = false;
      jackett.enable = true;
      plex.enable = true;
      radarr.enable = true;
      sonarr.enable = true;
      transmission.enable = true;
    };
    services = {
      adGuardHome.enable = true;
      miniflux.enable = true;
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
    nat = {
      enable = true;
      externalInterface = "wlan0";
    };
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
  fileSystems."/nix/persist/media" = {
    device = "/dev/disk/by-label/exthdd";
    fsType = "ntfs";
    options = [ "rw" "uid=1000" "gid=100" ];
  };
  swapDevices = [{ device = "/dev/disk/by-label/swap"; }];

  ## Performance stuff ##
  powerManagement.cpuFreqGovernor = lib.mkForce "powersaver";

  ##  Impermanence ##
  environment.persistence."/nix/persist" = {
    directories = [ "/media" "/home" ];
  };

  ## NFS ##
  services.nfs.server = {
    enable = true;
    exports = ''
    /media  100.110.26.48(rw,insecure,no_subtree_check) 100.91.89.2(rw,insecure,no_subtree_check)
    '';
  };

}

