{ ... }: {

  imports = [ ./modules ];

  device.type = "gaming-handheld";
  modules.gaming = {
    enable = true;
    steam.enable = true;
  };
  modules.system = {
    audio.enable = true;
    desktopEnvironment.jovian-nixos.enable = true;
    home.enable = true;
  };

}
