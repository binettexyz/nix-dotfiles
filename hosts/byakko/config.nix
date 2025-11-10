{
  config,
  flake,
  pkgs,
  ...
}: {
  #---Custom modules---#
  modules = {
    bootloader = {
      default = "grub";
      asRemovable = false;
      useOSProber = false;
    };
    device = {
      videoOutput = ["eDP-1" "HDMI-A-2"];
      storage.ssd = true;
      type = "laptop";
      tags = ["workstation" "dev" "battery" "lowSpec"];
    };
    system = {
      audio.enable = true;
      customFonts.enable = true;
      desktopEnvironment = "hyprland-uwsm";
      home.enable = true;
    };
  };

}
