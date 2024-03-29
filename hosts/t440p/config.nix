{ config, flake, lib, pkgs, system, ... }: {

  imports = [
    ../../nixos/default.nix
  ];

  ## Custom modules ##
  modules = {
    bootloader = "grub";
    device = {
      type = "laptop";
      netDevices = [ "enp0s25" "wlan0" ];
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

    # Networking
  networking = {
    interfaces.wlp3s0.useDHCP = true;
    interfaces.enp0s25.useDHCP = true;
    wireless = {
      interfaces =  [ "wlp3s0" ];
    };
  };

    # Trackpoint
  hardware.trackpoint = {
    enable = true;
    sensitivity = 300;
    speed = 100;
    emulateWheel = false;
  };

  nix.settings.max-jobs = 4;
  hardware.cpu.intel.updateMicrocode = true;
  services.throttled.enable = true;

}
