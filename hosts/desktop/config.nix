{ config, flake, lib, pkgs, system, ... }: 
  {

    imports = [ 
#      ../../modules/default.nix
      ./hardware.nix
      ../../nixos/default.nix
#      ../../nixos/system/default.nix
    ];

#  modules = {
#    bootloader = "grub";
#  };

  ## Custom modules ##
  modules = {
    bootloader = "grub";
    windowManager = "dwm";
    transmission.enable = false;
    services = {
      greenclip.enable = true;
      tty-login-prompt.enable = true;
    };
    profiles = {
      gaming.enable = true;
      core = {
        enable = true;
        bluetooth.enable = true;
        wifi.enable = true;
        print.enable = true;
        ssd.enable = true;
        virtmanager.enable = false;
      };
    };
  };

#    device = {
#      type = "desktop";
#      gpu = "nvidia";
#      netDevices = [ "enp34s0" ];
#    };
  
      # GPU
    services.xserver.videoDrivers = [ "nvidia" ];
    hardware = {
      nvidia = {
        modesetting.enable = true;
          # Enable experimental NVIDIA power management via systemd
        powerManagement.enable = true;
      };
      opengl.extraPackages = with pkgs; [ vaapiVdpau ];
    };
  
    ## Networking ##
    networking = {
      interfaces.wlo1.useDHCP = true;
      interfaces.enp34s0.useDHCP = true;
      interfaces.tailscale0.useDHCP = true;
    };
    
    nix.settings.max-jobs = 16; # ryzen 7 5800x
    hardware.cpu.amd.updateMicrocode = true;
    
    nixpkgs.config.allowUnfree = true;

}
