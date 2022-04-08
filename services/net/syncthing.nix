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
        id = "JXSGWKA-QFPVCRS-5MCBRGU-2KCOS6C-JZX27P6-CDKBFSF-QD7W27M-5ID3WQY";
      };
      "x240" = {
        introducer = true;
        id = "QYDL5PI-BIAEWEE-SB32DSL-4QHZKQV-2IMCBD7-THKBNZK-MCCMGXN-STNS4AX";
      };
      "phone" = {
        introducer = true;
        id = "FKGH2VG-FRX3CVK-ZFRJMON-OSWOVJI-TGOTQFY-4HTJEBB-RQKCFVN-OIYZQQE";
      };
    };
  };

}
