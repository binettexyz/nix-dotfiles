{ inputs, ... }:
{
  flake.nixosConfigurations = inputs.self.lib.mkNixos "x86_64-linux" "seiryu";
  flake.nixosModules.seiryu =
    { lib, ... }:
    {
      imports =
        with inputs.self.nixosModules;
        [
          binette
          consoleGamingPreset
          home-manager
          impermanence
          moondeck
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
        desktopEnvironment = "plasma";
        device = {
          cpu = "amd";
          hasBattery = true;
          hostname = "seiryu";
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
            "DP-3"
          ];
        };
      };

      #services.flatpak.packages = [
      #  "org.prismlauncher.PrismLauncher"
      #  "com.heroicgameslauncher.hgl"
      #  "net.retrodeck.retrodeck"
      #];

      # ---Stuff I Dont Want---
      services.timesyncd.enable = lib.mkForce false;
    };
}
