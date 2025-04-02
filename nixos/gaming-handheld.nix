{ lib, ... }: {

  imports = [ ./modules ];

  /* ---Custom Modules--- */
  device = {
    type = "gaming-handheld";
    hasBattery = true;
  };
  modules.gaming = {
    enable = true;
    steam.enable = true;
  };
  modules.system = {
    audio.enable = true;
    home.enable = true;
  };

  /* ---System Configuration--- */
  services.logind.powerKey = lib.mkForce "ignore";

}
