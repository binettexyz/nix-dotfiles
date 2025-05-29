{
  flake,
  pkgs,
  ...
}: {
  imports = [
    ../../home-manager
    flake.inputs.plasma-manager.homeManagerModules.plasma-manager
    flake.inputs.nix-colors.homeManagerModule
  ];

  colorScheme = import ../../modules/colorSchemes/gruvbox-material.nix;

  modules.hm = {
    gaming.enable = true;
    browser.librewolf.enable = true;
  };
}
