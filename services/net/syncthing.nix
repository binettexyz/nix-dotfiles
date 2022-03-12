{ config, lib, ... }: {

  services.syncthing = {
    enable = true;
    guiAddress = lib.mkDefault "localhost:8384";
    overrideDevices = true;     # overrides any devices added or deleted through the WebUI
    overrideFolders = true;     # overrides any folders added or deleted through the WebUI
#    ignorePerms = false;        # By default, Syncthing doesn't sync file permissions. This line enables it for this folder.

    devices = {
      "nas" = {
        introducer = true; # be allowed to add folders on this computer
        id = "WHM62RH-CAP2TDJ-KLJ5H2Y-RD777WP-FRPSYNU-YPBGFR3-XD6AUUE-4IHO3QA";
      };
      "x240" = {
        introducer = true;
        id = "FZO5TAS-UYMANM3-4NMGQHW-2NBUX6Z-RU6J3UH-6X2QLMQ-YIGH6Q7-WVD2GAY";
      };
      "phone" = {
        introducer = true;
        id = "FKGH2VG-FRX3CVK-ZFRJMON-OSWOVJI-TGOTQFY-4HTJEBB-RQKCFVN-OIYZQQE";
      };
    };
  };

}
