{ config, flake, pkgs, ... }:

let
  inherit (flake) inputs;
in {

  imports = [
    ../../home-manager/gaming-desktop.nix
    (flake.inputs.impermanence + "/home-manager.nix")
    flake.inputs.nix-colors.homeManagerModule
  ];

  colorScheme = import ../../modules/colorSchemes/gruvbox-material.nix;

}
