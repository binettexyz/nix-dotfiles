{
  lib,
  flake,
  pkgs,
  ...
}: {
  imports = [
    flake.inputs.sops-nix.nixosModules.sops
    flake.inputs.impermanence.nixosModules.impermanence
  ];

  # ---Custom modules---
  modules = {
    bootloader = {
      default = "grub";
      asRemovable = true;
      useOSProber = false;
    };
    gaming = {
      enable = true;
      device.isSteamdeck = true;
      steam.enable = true;
    };
    system = {
      audio.enable = true;
      desktopEnvironment = "hyprland-uwsm";
      home.enable = true;
    };
  };
  device.videoOutput = ["eDP-1" "DP-3"];
  device.hasBattery = true;

  # ---Networking---
  networking = {
    interfaces.wlo1.useDHCP = true;
    interfaces.tailscale0.useDHCP = true;
  };

  # ---Stuff I Dont Want---
  services.timesyncd.enable = lib.mkForce false;

  environment.systemPackages = with pkgs; [zsh];
}
