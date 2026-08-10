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
          desktopGamingPreset
          home-manager
          impermanence
          jovian
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
            "workstation"
          ];
          videoOutputs = [
            "eDP-1"
            "DP-3"
          ];
        };
      };
    };
}
