{ config, lib, flake, pkgs, ... }:

let
  inherit (flake) inputs;
in {

  imports = [
    ./hardware.nix
    ../../nixos/gaming-handheld.nix
    flake.inputs.sops-nix.nixosModules.sops
    flake.inputs.impermanence.nixosModules.impermanence
    flake.inputs.jovian-nixos.nixosModules.jovian
  ];

  /* ---Custom modules--- */
  modules.bootloader = {
    default = "grub";
    asRemovable = true;
    useOSProber = false;
  };
  modules.system.desktopEnvironment.default = "plasma";
  device = {
    gpu = "amd";
    netDevices = [ "wlo1" ];
  };

  /* ---Networking--- */
  networking = {
    interfaces.wlo1.useDHCP = true;
    interfaces.tailscale0.useDHCP = true;
  };

  /* ---Stuff I Dont Want--- */
  services.timesyncd.enable = lib.mkForce false;

  environment.systemPackages = with pkgs; [ zsh ];
}

