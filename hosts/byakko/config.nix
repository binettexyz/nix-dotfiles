{
  config,
  flake,
  ...
}: {
  #---Custom modules---#
  modules = {
    bootloader = {
      default = "grub";
      asRemovable = false;
      useOSProber = false;
    };
    system = {
      audio.enable = true;
      customFonts.enable = true;
      desktopEnvironment = "hyprland-uwsm";
      home.enable = true;
    };
  };

  device.videoOutput = ["eDP-1" "HDMI-A-2"];
  device.storage.ssd = true;

}
