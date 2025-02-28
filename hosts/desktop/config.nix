{ config, flake, pkgs, ... }:

let
  inherit (flake) inputs;
in {

  imports = [ 
    ./hardware.nix
    ../../nixos/gaming-desktop.nix
    #../../nixos/libvirt
    flake.inputs.sops-nix.nixosModules.sops
    flake.inputs.impermanence.nixosModules.impermanence 
  ];

  ## Custom modules ##
  modules.bootloader = {
    default = "grub";
    asRemovable = false;
    useOSProber = false;
  };
  modules.system.desktopEnvironment.default = "plasma";
  device = {
    gpu = "amd";
    netDevices = [ "enp34s0" "wlo1" ];
  };

  ## Networking ##
  networking = {
    interfaces.wlo1.useDHCP = true;
    interfaces.enp34s0.useDHCP = true;
  };
  
  environment.systemPackages = with pkgs; [ zsh ];
}
