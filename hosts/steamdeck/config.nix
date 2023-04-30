{ config, flake, lib, pkgs, system, ... }: {

    imports = [ 
        #../../nixos/default.nix
        #../../nixos/gaming
    ];

    ## Custom modules ##
    modules = {
        bootloader = "grub";
        device = {
            type = "Console";
            gpu = "---";
            netDevices = [ "wlo1" ];
        };
    };
  
    ## GPU ##
  
    ## Networking ##
    networking = {
        interfaces.wlo1.useDHCP = true;
        #interfaces.---.useDHCP = true;
        #interfaces.tailscale0.useDHCP = true;
    };

    # Enable the Plasma 5 Desktop Environment.
  services.xserver.displayManager.sddm.enable = true;
  services.xserver.desktopManager.plasma5.enable = true;
    
    nix.settings.max-jobs = 8;
}
