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

  device.videoOutput = ["eDP-1"];
  device.storage.ssd = true;

  services.thinkfan = {
    enable = true;
    sensors = [ { type = "tpacpi"; query = "/proc/acpi/ibm/thermal"; indices = [ 0 1 2 ]; } ];
    fans = [ { type = "tpacpi"; query = "/proc/acpi/ibm/fan"; } ];
    levels = [
      [0 0 55]
      [1 55 60]
      [2 60 63]
      [3 63 66]
      [4 66 70]
      [5 70 72]
      [6 72 75]
      [7 75 80]
      ["level auto" 80 255]
    ];
  };
}
