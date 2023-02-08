{ config, flake, lib, pkgs, system, ... }: 
  {

    imports = [ 
#      ../../modules/default.nix
      ./hardware.nix
      ../../modules/system/default.nix
#    ../../nixos/system/default.nix
    ];

  ## Custom modules ##
  modules = {
    bootloader = "grub";
    windowManager = "dwm";
#    desktopEnvironment = null;
    services = {
      greenclip.enable = true;
      tty-login-prompt.enable = true;
    };
    profiles = {
      laptop.enable = true;
      server.enable = false;
      core = {
        enable = true;
        bluetooth.enable = false;
        wifi.enable = true;
        print.enable =false;
        ssd.enable = true;
        virtmanager.enable = false;
      };
    };
  };

#    device = {
#      type = "laptop";
#      netDevices = [ "" ];
#    };
  
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
  
    ## Networking ##
    networking = {
      interfaces.wlan0.useDHCP = true;
      interfaces.enp0s25.useDHCP = true;
      wireless = {
        interfaces =  [ "wlan0" ];
      };
    };

      # Trackpoint
    hardware.trackpoint = {
      enable = true;
      sensitivity = 300;
      speed = 100;
      emulateWheel = false;
    };

    nix.settings.max-jobs = 4; # ryzen 7 5800x
    hardware.cpu.amd.updateMicrocode = true;
    services.throttled.enable = false;
    
    networking.hostName = "x240";

    nixpkgs.config.allowUnfree = true;
}
