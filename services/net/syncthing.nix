{ config, lib, ... }: {

  services.syncthing = {
    enable = true;
    guiAddress = lib.mkDefault "localhost:8384";
    overrideDevices = true;     # overrides any devices added or deleted through the WebUI
    overrideFolders = true;     # overrides any folders added or deleted through the WebUI

     devices = {
       "nas" = {
         introducer = true; # be allowed to add folders on this computer
         id = "WHM62RH-CAP2TDJ-KLJ5H2Y-RD777WP-FRPSYNU-YPBGFR3-XD6AUUE-4IHO3QA";
       };
       "x240" = {
         introducer = true; # be allowed to add folders on this computer
         id = "FZO5TAS-UYMANM3-4NMGQHW-2NBUX6Z-RU6J3UH-6X2QLMQ-YIGH6Q7-WVD2GAY";
       };
    };
  };

}
