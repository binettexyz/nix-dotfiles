{ config, flake, lib, pkgs, system, ... }: {

    imports = [ 
      ../../nixos/minimal.nix
    ];

    ## Networking ##
    networking = {
        interfaces.wlo1.useDHCP = true;
        #interfaces.---.useDHCP = true;
        #interfaces.tailscale0.useDHCP = true;
    };

    # Enable the Plasma 5 Desktop Environment.
    services.xserver.enable = true;
    services.xserver.displayManager.sddm.enable = true;
    services.xserver.desktopManager.plasma5.enable = true;
    
    nix.settings.max-jobs = 8;
}
