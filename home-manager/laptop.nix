{ lib, ... }: {

  imports = [ ./modules ];

  device.type = "laptop";

  modules.hm = {
    browser.librewolf.enable = true;
    browser.qutebrowser.enable = true;
    mpv = {
      enable = true;
      lowSpec = true;
    };
  };

}
