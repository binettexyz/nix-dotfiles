{ config, ... }:
{
  flake.nixosModules.syncthing = {
    services.syncthing = {
      enable = true;
      group = config.home.username;
      user = config.home.username;
      configDir = "/home/${config.home.username}/.config/syncthing"; # Folder for Syncthing's settings and keys
      dataDir = "/home/${config.home.username}/.local/sync";
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
          "genbu" = {
            id = "3H6X5PB-BXBVXDM-FEI4VNL-EXEPUNM-6VW6TWO-273GWRH-4QA3EYS-OOETRQN";
            autoAcceptFolders = false;
          };
          "byakko" = {
            id = "YJDWZRL-XHRLD6X-Z5U5YG4-BQE44GI-PMU4RD4-LPNYCZF-4SUY5RY-2VMFQQK";
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
