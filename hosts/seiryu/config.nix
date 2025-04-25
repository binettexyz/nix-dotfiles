{flake, ...}: {
  imports = [
    flake.inputs.sops-nix.nixosModules.sops
    flake.inputs.impermanence.nixosModules.impermanence
  ];

  ## Custom modules ##
  modules = {
    bootloader = {
      default = "grub";
      asRemovable = false;
      useOSProber = false;
    };
    gaming = {
      enable = true;
      steam.enable = true;
      valveControllersRules = true;
      openPorts = false;
    };
    system = {
      audio.enable = true;
      customFonts.enable = true;
      desktopEnvironment = "hyprland";
      home.enable = true;
    };
  };

  device.videoOutput = ["HDMI-A-1" "HDMI-A-2"];
  device.storage = {
    ssd = true;
    hdd = true;
  };

  ## Networking ##
  networking = {
    interfaces.wlo1.useDHCP = true;
    interfaces.enp34s0.useDHCP = true;
  };
}
