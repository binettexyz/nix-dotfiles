{ inputs, ... }:
let
  host = "katana";
  system = "x86_64-linux";
in
{
  flake.nixosConfigurations = inputs.self.lib.mkNixos system host;
  flake.nixosModules.${host} = {
    imports = with inputs.self.nixosModules; [
      binette
      desktopGamingPreset
      home-manager
      impermanence
      sunshine
      jovian
    ];

    modules = {
      bootloader = {
        default = "grub";
        asRemovable = false;
        useOSProber = false;
      };
      desktopEnvironment = "hyprland-uwsm"; # plasma, hyprland-uwsm
      device = {
        cpu = "amd";
        hostname = host;
        storage = {
          hdd = true;
          ssd = true;
        };
        type = "desktop";
        tags = [
          "console"
          "workstation"
          "highSpec"
        ];
        videoOutputs = [
          "DP-1"
        ];
      };
    };

    services.udev.extraRules = ''
      # Disable wake on USB
      ACTION=="add", SUBSYSTEM=="usb", DRIVERS=="usb", ATTRS{idVendor}=="046d", ATTRS{idProduct}=="c548", ATTR{power/wakeup}="disabled", ATTR{driver/3-3/power/wakeup}="disabled"
      ACTION=="add", SUBSYSTEM=="usb", DRIVERS=="usb", ATTRS{idVendor}=="046d", ATTRS{idProduct}=="c547", ATTR{power/wakeup}="disabled", ATTR{driver/1-1/power/wakeup}="disabled"
      ACTION=="add", SUBSYSTEM=="usb", DRIVERS=="usb", ATTRS{idVendor}=="3434", ATTRS{idProduct}=="0c10", ATTR{power/wakeup}="disabled", ATTR{driver/1-2/power/wakeup}="disabled"
    '';
  };
}
