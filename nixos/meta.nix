{ config, pkgs, inputs, ... }:

{
  imports = [
#    ../cachix.nix
#    ../overlays
  ];

  # Add some Nix related packages
  environment.systemPackages = with pkgs; [
#    cachix
#    nixos-cleanup
  ];

  system.stateVersion = "22.05"; # Did you read the comment?

  nix = import ../shared/nix.nix { inherit pkgs inputs; };

  # Enable unfree packages
  nixpkgs.config.allowUnfree = true;
}
