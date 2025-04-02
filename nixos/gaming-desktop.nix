{ lib, ... }: {

  imports = [ ./modules ];

  /* ---Custom Modules--- */
  device.type = "gaming-desktop";
  modules.gaming = {
    enable = true;
    steam.enable = true;
    openPorts = true;
  };
  modules.system = {
    audio.enable = true;
    customFonts.enable = true;
    desktopEnvironment = "qtile";
    home.enable = true;
  };

}
