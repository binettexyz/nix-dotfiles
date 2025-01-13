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

    # Without git we may be unable to build this config
  programs.git = {
    enable = true;
    config = {
        # Avoid git log spam while building this config
      init.defaultBranch = "master";
    };
  };

  system.stateVersion = "24.11"; # Did you read the comment?

  nix = import ../../shared/nix.nix { inherit pkgs flake; };

    # Enable unfree packages
  nixpkgs.config.allowUnfree = true;

    # Change build dir to /var/tmp
  systemd.services.nix-daemon.environment.TMPDIR = "/tmp";

}
