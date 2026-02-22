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
            "HDMI-A-2"
          ];
        };
      };

      # Only suspend on lid closed when laptop is disconnected
      services.logind.settings.Login = {
        HandleLidSwitch = lib.mkForce "suspend";
        #HandleLidSwitchDocked = lib.mkForce "ignore";
        #HandleLidSwitchExternalPower = lib.mkForce "ignore";
        HandlePowerKey = "suspend";
      };

    };
}
