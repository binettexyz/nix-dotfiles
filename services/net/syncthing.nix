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
        id = "FEJGDDQ-2RF5L6E-H5TWFOF-OMV4VSM-37W4CHX-H7MS4RP-B4CMRYK-C2DVNAN";
      };
      "x240" = {
        introducer = true;
        id = "LZMYNS6-F6DSO36-IEMZUK3-UQHLQYD-ZHAHOSE-XK2TXYM-HY4XP2U-QRVG2AN";
      };
      "phone" = {
        introducer = true;
        id = "FKGH2VG-FRX3CVK-ZFRJMON-OSWOVJI-TGOTQFY-4HTJEBB-RQKCFVN-OIYZQQE";
      };
    };
  };

}
