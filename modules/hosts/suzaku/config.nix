{ inputs, ... }:
{
  flake.nixosConfigurations = inputs.self.lib.mkNixos "x86_64-linux" "suzaku";
  flake.nixosModules.suzaku = {
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
      desktopEnvironment = "plasma";
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

    #services.flatpak.packages = [
    #  "org.prismlauncher.PrismLauncher"
    #  "com.heroicgameslauncher.hgl"
    #  "net.retrodeck.retrodeck"
    #  "dev.vencord.Vesktop"
    #];
  };
}
