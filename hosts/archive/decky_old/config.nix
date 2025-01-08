{ config, flake, pkgs, ... }:

let
  inherit (flake) inputs;
in {

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

