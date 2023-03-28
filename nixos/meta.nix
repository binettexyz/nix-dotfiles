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

    # Without git we may be unable to build this config
  programs.git = {
    enable = true;
    config = {
        # Avoid git log spam while building this config
      init.defaultBranch = "master";
    };
  };

  system.stateVersion = "22.05"; # Did you read the comment?

  nix = import ../shared/nix.nix { inherit pkgs inputs; };

  # Enable unfree packages
  nixpkgs.config.allowUnfree = true;
}
