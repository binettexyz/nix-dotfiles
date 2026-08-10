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
      consoleGamingPreset
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
      desktopEnvironment = "plasma"; # plasma, hyprland-uwsm
      device = {
        cpu = "amd";
        hostname = host;
        storage = {
          hdd = true;
          ssd = true;
        };
        type = "console";
        tags = [
          "console"
          "highSpec"
        ];
        videoOutputs = [
        ];
      };
    };
  };
}
