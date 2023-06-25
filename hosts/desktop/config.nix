{ config, pkgs, flake, ... }:

let
  inherit (flake) inputs;
in

  {

    imports = [ 
        ./hardware.nix
        ../../nixos/default.nix
#        ../../nixos/gaming
#        ../../nixos/libvirt
        flake.inputs.sops-nix.nixosModules.sops
        flake.inputs.impermanence.nixosModules.impermanence 
        flake.inputs.nix-gaming.nixosModules.pipewireLowLatency 
    ];

    ## Custom modules ##
    modules = { bootloader = "grub"; };
    device = {
        type = "desktop";
        gpu = "nvidia";
        netDevices = [ "enp34s0" "wlo1" ];
    };
  
      # GPU
    hardware.nvidia = {
        modesetting.enable = true;
        #package = config.boot.kernelPackages.nvidiaPackages.vulkan_beta;
          # Enable experimental NVIDIA power management via systemd
        powerManagement.enable = true;
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
