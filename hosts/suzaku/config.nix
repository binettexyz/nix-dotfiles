{
  config,
  flake,
  ...
}: {

  ## Custom modules ##
  modules = {
    bootloader = {
      default = "grub";
      asRemovable = false;
      useOSProber = false;
    };
    device = {
      storage = {
        hdd = true;
        ssd = true;
      };
      tags = [ "workstation" "console" "gaming" "highSpec" ];
      type = "desktop";
      videoOutput = ["HDMI-A-1" "HDMI-A-2"];
    };
    gaming.enable = true;
    system = {
      audio.enable = true;
      customFonts.enable = true;
      desktopEnvironment = "plasma";
      home.enable = true;
    };
  };

  ## Mouse Acceleration ##
  hardware.yeetmouse = {
    enable = true;
    sensitivity = 1.65;
    outputCap = 2.0;
    rotation.angle = 5.0;
    mode.synchronous = {
      gamma = 10.0;
      smoothness = 0.5;
      motivity = 4.0;
      syncspeed = 30.0;
    };
  };

  ## Networking ##
  networking = {
    interfaces.wlo1.useDHCP = true;
    interfaces.enp34s0.useDHCP = true;
  };
}
