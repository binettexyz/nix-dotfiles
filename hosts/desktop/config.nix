{ config, flake, pkgs, ... }:

let
  inherit (flake) inputs;
in {

  imports = [ 
    ./hardware.nix
    ../../nixos/default.nix
    ../../nixos/gaming
    #../../nixos/libvirt
    flake.inputs.sops-nix.nixosModules.sops
    flake.inputs.impermanence.nixosModules.impermanence 
    flake.inputs.nix-gaming.nixosModules.pipewireLowLatency 
  ];

  ## Custom modules ##
  modules = {
    bootloader = "grub";
    desktopEnvironment = null;
  };
  device = {
    type = "desktop";
    gpu = "nvidia";
    netDevices = [ "enp34s0" "wlo1" ];
  };

  ## GPU ##
  hardware.nvidia = {
    package = config.boot.kernelPackages.nvidiaPackages.latest;
      # Use the open source version of the kernel module
    open = true;
      # Needed for most wayland compositor
    modesetting.enable = true;
      # Enable experimental NVIDIA power management via systemd
    #powerManagement.enable = true;
  };

  ## Networking ##
  networking = {
    interfaces.wlo1.useDHCP = true;
    interfaces.enp34s0.useDHCP = true;
    interfaces.tailscale0.useDHCP = true;
  };
  
  nix.settings.max-jobs = 16; # ryzen 7 5800x
  networking.hostName = "desktop";

}
