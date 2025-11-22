{ lib, ... }:
{
  # ---Custom modules---
  modules = {
    bootloader = {
      default = "grub";
      asRemovable = true;
      useOSProber = false;
    };
    device = {
      videoOutput = [
        "eDP-1"
        "DP-3"
      ];
      hasBattery = true;
      storage.ssd = true;
      type = "handheld";
      tags = [
        "battery"
        "console"
        "gaming"
        "lowSpec"
        "steamdeck"
        "touchscreen"
      ];
    };
    gaming = {
      enable = true;
      device.isSteamdeck = true;
    };
    system = {
      audio.enable = true;
      desktopEnvironment = "plasma";
      home.enable = true;
    };
  };

  # ---Networking---
  networking = {
    interfaces.wlo1.useDHCP = true;
    interfaces.tailscale0.useDHCP = true;
  };

  # ---Stuff I Dont Want---
  services.timesyncd.enable = lib.mkForce false;
}
