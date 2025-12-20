{
  config,
  flake,
  lib,
  ...
}:
{
  imports = [
    flake.inputs.yeetmouse.nixosModules.default
    flake.inputs.nix-flatpak.nixosModules.nix-flatpak
  ];

  ## Custom modules ##
  modules = {
    bootloader = {
      default = "grub";
      asRemovable = false;
      useOSProber = false;
    };
    device = {
      storage = {
        hdd = true;
        ssd = true;
      };
      tags = [
        "workstation"
        "console"
        "gaming"
        "highSpec"
      ];
      type = "desktop";
      videoOutput = [
        "HDMI-A-1"
        "HDMI-A-2"
      ];
    };
    gaming = {
      enable = true;
      services.sunshine.enable = true;
    };
    system = {
      audio.enable = true;
      customFonts.enable = true;
      desktopEnvironment = "plasma";
      home.enable = true;
    };
  };

  services.flatpak.packages = [
    "org.prismlauncher.PrismLauncher"
    "com.heroicgameslauncher.hgl"
    "net.retrodeck.retrodeck"
    "dev.vencord.Vesktop"
  ];

  services.logind.settings.Login.HandlePowerKey = lib.mkForce "sleep";

  ## Mouse Acceleration ##
  hardware.yeetmouse = {
    enable = true;
    sensitivity = 1.65;
    outputCap = 2.0;
    rotation.angle = 5.0;
    mode.synchronous = {
      gamma = 10.0;
      smoothness = 0.5;
      motivity = 4.0;
      syncspeed = 30.0;
    };
  };
}
