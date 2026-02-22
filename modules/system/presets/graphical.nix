{ inputs, ... }:
{
  flake.nixosModules.graphicalPreset = {
    imports = with inputs.self.nixosModules; [
      audio
      bluetooth
      desktopEnvironment
      fonts
      minimalPreset
    ];
  };

  flake.modules.homeManager.graphicalPreset = {
    imports = with inputs.self.modules.homeManager; [
      hyprland
      minimalPreset
      plasma
      qtile
      theme
    ];
  };
}
