{
  lib,
  pkgs,
  ...
}: {
  # Add some Nix related packages
  home.packages = [
    #    pkgs.hydra-check
    #    pkgs.nix-cleanup
    #    pkgs.nix-update
    #    pkgs.nix-whereis
    #    pkgs.nixpkgs-fmt
  ];

  # To make cachix work you need add the current user as a trusted-user on Nix
  # sudo echo "trusted-users = $(whoami)" >> /etc/nix/nix.conf
  # Another option is to add a group by prefixing it by @, e.g.:
  # sudo echo "trusted-users = @wheel" >> /etc/nix/nix.conf
  nix.package = lib.mkDefault pkgs.nix;

  xdg.configFile."nixpkgs/config.nix".source = ./nixpkgs-config.nix;

  programs = {
    # Let Home Manager install and manage itself.
    home-manager.enable = true;
    # Without git we may be unable to build this config
    git.enable = true;
  };

  home.stateVersion = "22.11";

  # Inherit config from NixOS or homeConfigurations
  #  device = super.device;
  #  meta = super.meta;
}
