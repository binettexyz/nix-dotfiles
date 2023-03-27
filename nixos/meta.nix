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

  programs = {
      # Without git we may be unable to build this config
    git = {
      enable = true;
      config = {
          # Avoid git log spam while building this config
        init.defaultBranch = "master";
      };
    };
      # This will cause the zsh shell to lack
      # the basic nix directories in its PATH
    zsh.enable = true;
  };

  system.stateVersion = "22.05"; # Did you read the comment?

  nix = import ../shared/nix.nix { inherit pkgs inputs; };

  # Enable unfree packages
  nixpkgs.config.allowUnfree = true;
}
