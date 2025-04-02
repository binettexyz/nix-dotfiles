{ config, pkgs, flake, ... }:

{
  imports = [
    ../../shared/adblock.nix
#    ../cachix.nix
  ];

  # Add some Nix related packages
  environment.systemPackages = with pkgs; [
    nixos-cleanup
    nix-rebuild
  ];

  programs = {
    git.enable = true;
    git.config = {
        # Avoid git log spam while building this config
      init.defaultBranch = "master";
    };
      # Alternative to nixos-rebuild.
    nh.enable = true;
    nh.flake = "/etc/nixos";
  };

  system.stateVersion = "24.11"; # Did you read the comment?

  nix = import ../../shared/nix.nix { inherit pkgs flake; };

    # Enable unfree packages
  nixpkgs.config.allowUnfree = true;

    # Change build dir to /var/tmp
  systemd.services.nix-daemon.environment.TMPDIR = "/tmp";

}
