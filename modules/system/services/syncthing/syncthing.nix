{
  flake.nixosModules.syncthing =
    { config, ... }:
    {
      services.syncthing = {
        enable = true;
        group = config.meta.username;
        user = config.meta.username;
        configDir = "/home/${config.meta.username}/.config/syncthing"; # Folder for Syncthing's settings and keys
        dataDir = "/home/${config.meta.username}/.local/sync";
        overrideDevices = true; # overrides any devices added or deleted through the WebUI
        overrideFolders = false; # overrides any folders added or deleted through the WebUI
        settings = {
          gui.theme = "black";
          devices = {
            "suzaku" = {
              id = "QK7TWSU-CYQOBEW-MBBEVWM-X37XHVY-GSIBOCM-YHBDRJE-BNM2TIA-ZGW4MQX";
              autoAcceptFolders = true;
            };
            "seiryu" = {
              id = "VHONWML-AZNC73N-KBJ62KW-NEM27CZ-ZRDTB34-TUHPCYS-7X4B2HF-4L7NTQA";
              autoAcceptFolders = true;
            };
            "ouryuu" = {
              id = "TEGLOVR-2AL23J2-5C5XDT7-X3DKOIM-E5QBGA5-M6FVRUA-A5TEJ3J-P3VEUAQ";
              autoAcceptFolders = false;
            };
            "byakko" = {
              id = "55FSEXM-6SGGQXG-IUSWZ4X-Q7SVLY7-SU7UV3G-5XJUZRP-6I7KMQH-NB74IAF";
              autoAcceptFolders = true;
            };
          };
        };
        #      gui = {
        #        user = username;
        #        password = "";
        #      };
      };

    };
}
