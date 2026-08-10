{ inputs, ... }:
{
  flake.nixosConfigurations = inputs.self.lib.mkNixos "x86_64-linux" "wakizashi";
  flake.nixosModules.wakizashi =
    { lib, ... }:
    {
      imports =
        with inputs.self.nixosModules;
        [
          binette
          consoleGamingPreset
          home-manager
          impermanence
        ]
        ++ [
          inputs.nix-flatpak.nixosModules.nix-flatpak
        ];

      modules = {
        bootloader = {
          default = "grub";
          asRemovable = true;
          useOSProber = false;
        };
        desktopEnvironment = "hyprland-uwsm";
        device = {
          cpu = "amd";
          hasBattery = true;
          hostname = "wakizashi";
          storage.ssd = true;
          type = "handheld";
          tags = [
            "battery"
            "console"
            "gaming"
            "lowSpec"
            "steamdeck"
            "touchscreen"
          ];
          videoOutputs = [
            "eDP-1"
            "DP-4"
          ];
        };
      };

      # ---Stuff I Dont Want---
      services.timesyncd.enable = lib.mkForce false;
    };
}
