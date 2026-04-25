{ inputs, ... }:
{
  flake.nixosConfigurations = inputs.self.lib.mkNixos "x86_64-linux" "suzaku";
  flake.nixosModules.suzaku =
    { lib, ... }:
    {
      imports = with inputs.self.nixosModules; [
        binette
        desktopGamingPreset
        home-manager
        impermanence
        sunshine
      ];

      modules = {
        bootloader = {
          default = "grub";
          asRemovable = false;
          useOSProber = false;
        };
        desktopEnvironment = "hyprland";
        device = {
          cpu = "amd";
          hostname = "suzaku";
          storage = {
            hdd = true;
            ssd = true;
          };
          type = "desktop";
          tags = [
            "workstation"
            "gaming"
            "highSpec"
          ];
          videoOutputs = [
            "HDMI-A-1"
            "HDMI-A-2"
          ];
        };
      };

      services.logind.settings.Login = {
        HandlePowerKey = lib.mkForce "suspend";
      };

      services.udev.extraRules = ''
        # Keychron keyboard acces from webapp
        KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="3434", ATTRS{idProduct}=="0c10", MODE="0660", GROUP="binette", TAG+="uaccess", TAG+="udev-acl"
        # Disable wake on USB
        ACTION=="add", SUBSYSTEM=="usb", DRIVERS=="usb", ATTRS{idVendor}=="046d", ATTRS{idProduct}=="c548", ATTR{power/wakeup}="disabled", ATTR{driver/3-3/power/wakeup}="disabled"
        ACTION=="add", SUBSYSTEM=="usb", DRIVERS=="usb", ATTRS{idVendor}=="046d", ATTRS{idProduct}=="c547", ATTR{power/wakeup}="disabled", ATTR{driver/1-1/power/wakeup}="disabled"
        ACTION=="add", SUBSYSTEM=="usb", DRIVERS=="usb", ATTRS{idVendor}=="3434", ATTRS{idProduct}=="0c10", ATTR{power/wakeup}="disabled", ATTR{driver/1-2/power/wakeup}="disabled"
      '';

      #services.flatpak.packages = [
      #  "org.prismlauncher.PrismLauncher"
      #  "com.heroicgameslauncher.hgl"
      #  "net.retrodeck.retrodeck"
      #  "dev.vencord.Vesktop"
      #];
    };
}
