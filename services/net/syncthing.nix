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
        id = "WBBICHO-UGY7YDG-ZZLDFQN-GCVPACG-ABJSPK4-ZNHBCNR-KQOHVFO-VNMPUQU";
      };
      "x240" = {
        introducer = true;
        id = "7Y6DE45-OR6OTCR-BIUGNPB-RLTRUMI-KQVPFQR-E5EMSAN-ZDBFK32-JMWKJQE";
      };
      "phone" = {
        introducer = true;
        id = "FKGH2VG-FRX3CVK-ZFRJMON-OSWOVJI-TGOTQFY-4HTJEBB-RQKCFVN-OIYZQQE";
      };
    };
  };

}
