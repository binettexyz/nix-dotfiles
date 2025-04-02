{ lib, ... }: {

  imports = [ ./modules ];

  /* ---Custom Modules--- */
  device.type = "gaming-handheld";
  device.hasBattery = true;
  modules = {
    gaming.enable = true;
    gaming.steam.enable = true;
    system.audio.enable = true;
    system.home.enable = true;
  };

  /* ---System Configuration--- */
  services.logind.powerKey = lib.mkForce "ignore";

}
