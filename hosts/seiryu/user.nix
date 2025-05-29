{ flake, ... }: {

  imports = [
    ../../home-manager
    (flake.inputs.impermanence + "/home-manager.nix")
    flake.inputs.nix-colors.homeManagerModule
    flake.inputs.plasma-manager.homeManagerModules.plasma-manager
  ];

  modules.hm = {
    gaming.enable = true;
    gui.packages = true;
    browser.librewolf.enable = true;
    mpv = {
      enable = true;
      lowSpec = false;
    };
    theme = {
      colorScheme = "gruvbox";
      wallpaper = "003";
    };
  };

}
