{ config, flake, lib, pkgs, system, ... }: {

    imports = [
      ./hardware.nix
      ../../nixos/steamdeck.nix
    ];

    ## Networking ##
    networking = {
        interfaces.wlo1.useDHCP = true;
        #interfaces.---.useDHCP = true;
        #interfaces.tailscale0.useDHCP = true;
    };

    nix.settings.max-jobs = 8;
}
