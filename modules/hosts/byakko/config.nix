{ inputs, ... }:
{
  flake.nixosConfigurations = inputs.self.lib.mkNixos "x86_64-linux" "byakko";
  flake.nixosModules.byakko =
    { lib, ... }:
    {
      imports = with inputs.self.nixosModules; [
        binette
        home-manager
        impermanence
        laptopPreset
        steam
      ];

      modules = {
        bootloader = {
          default = "grub";
          asRemovable = false;
          useOSProber = false;
        };
        desktopEnvironment = "hyprland";
        device = {
          cpu = "intel";
          hostname = "byakko";
          storage = {
            ssd = true;
          };
          type = "laptop";
          tags = [
            "workstation"
            "dev"
            "battery"
            "lowSpec"
          ];
          videoOutputs = [
            "eDP-1"
            "DP-1"
          ];
        };
      };

      # Only suspend on lid closed when laptop is disconnected
      services.logind.settings.Login = {
        HandleLidSwitch = lib.mkForce "suspend";
        HandleLidSwitchDocked = lib.mkForce "ignore";
        HandleLidSwitchExternalPower = lib.mkForce "ignore";
        HandlePowerKey = "suspend";
      };

      services.flatpak.packages = [
        "com.teamspeak.TeamSpeak"
        "com.teamspeak.TeamSpeak3"
      ];

      #      services.kanata = {
      #        enable = true;
      #        keyboards.default = {
      #          config = ''
      #            (defsrc
      #              rshift 1 2 3 4 5 6 7 8 9 0
      #            )
      #
      #            (deflayer base
      #              (layer-while-held game)
      #              1 2 3 4 5 6 7 8 9 0
      #            )
      #
      #            (deflayer game
      #              rshift
      #              (multi spc 1)
      #              (multi spc 2)
      #              (multi spc 3)
      #              (multi spc 4)
      #              (multi spc 5)
      #              (multi spc 6)
      #              (multi spc 7)
      #              (multi spc 8)
      #              (multi spc 9)
      #              (multi spc 0)
      #            )
      #          '';
      #        };
      #      };
    };
}
