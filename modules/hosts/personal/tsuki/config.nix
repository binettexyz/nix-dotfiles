{ inputs, ... }:
let
  host = "tsuki";
  system = "x86_64-linux";
in
{
  flake.nixosConfigurations = inputs.self.lib.mkNixos system host;
  flake.nixosModules.${host} =
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
        desktopEnvironment = "hyprland-uwsm";
        device = {
          cpu = "intel";
          hostname = host;
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
          ];
        };
      };

      services.logind.settings.Login = {
        HandleLidSwitch = lib.mkForce "suspend";
        #HandleLidSwitchDocked = lib.mkForce "ignore";
        #HandleLidSwitchExternalPower = lib.mkForce "ignore";
        HandlePowerKey = "suspend";
      };
    };
}
