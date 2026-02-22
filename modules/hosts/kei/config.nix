{ inputs, ... }:
{
  flake.nixosConfigurations = inputs.self.lib.mkNixos "x86_64-linux" "kei";
  flake.nixosModules.kei = {
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
        hostname = "kei";
        storage.hdd = true;
        type = "laptop";
        tags = [
          "workstation"
          "dev"
          "battery"
          "lowspec"
        ];
        videoOutputs = [ "eDP-1" ];
      };
    };
  };
}
