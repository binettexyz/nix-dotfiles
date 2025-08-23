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

  modules.hm = {
    gaming.enable = true;
    browser.librewolf.enable = true;
    theme = {
      colorScheme = "gruvbox";
      wallpaper = "003";
    };
  };
}
