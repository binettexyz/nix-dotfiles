{flake, ...}: {
  imports = [
    ../../home-manager
    (flake.inputs.impermanence + "/home-manager.nix")
    flake.inputs.nix-colors.homeManagerModule
    flake.inputs.plasma-manager.homeModules.plasma-manager
  ];

  modules.hm = {
    gaming.enable = true;
    gui.packages = true;
    browser.librewolf.enable = true;
    theme = {
      colorScheme = "gruvbox";
      wallpaper = "003";
    };
  };
}
