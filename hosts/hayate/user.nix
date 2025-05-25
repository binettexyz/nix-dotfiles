{flake, ...}: let
  inherit (flake) inputs;
in {
  imports = [
    ../../home-manager
    (inputs.impermanence + "/home-manager.nix")
    flake.inputs.nix-colors.homeManagerModule
    flake.inputs.plasma-manager.homeManagerModules.plasma-manager
    #    flake.inputs.nixvim.homeManagerModules.nixvim
  ];

  #colorScheme = import ../../modules/colorSchemes/gruvbox-material.nix;

  modules.hm = {
    browser = {
      librewolf.enable = true;
      qutebrowser.enable = true;
    };
    mpv.enable = true;
    theme = {
      colorScheme = "gruvbox-material";
    };
  };
}
