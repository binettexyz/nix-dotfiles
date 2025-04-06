{
  config,
  lib,
  flake,
  pkgs,
  ...
}:

let
  inherit (flake) inputs;
in
{

  imports = [
    ./hardware.nix
    ../../nixos/gaming-handheld.nix
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
      desktopEnvironment = "plasma";
      home.enable = true;
    };
  };
  device = {
    gpu = "amd";
    hasBattery = true;
  };

  # ---Networking---
  networking = {
    interfaces.wlo1.useDHCP = true;
    interfaces.tailscale0.useDHCP = true;
  };

  # ---Stuff I Dont Want---
  services.timesyncd.enable = lib.mkForce false;

  environment.systemPackages = with pkgs; [ zsh ];
}
