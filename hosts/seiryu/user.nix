{ flake, ... }:
let
  inherit (flake) inputs;
in
{

  imports = [
    ../../home-manager
    (flake.inputs.impermanence + "/home-manager.nix")
    flake.inputs.nix-colors.homeManagerModule
    flake.inputs.plasma-manager.homeManagerModules.plasma-manager
  ];

  colorScheme = import ../../modules/colorSchemes/gruvbox-material.nix;

  modules.hm = {
    gaming.enable = true;
    browser.librewolf.enable = true;
    mpv = {
      enable = true;
      lowSpec = false;
    };
  };

}
