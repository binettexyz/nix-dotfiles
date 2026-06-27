{ inputs, ... }:
{
  flake.nixosModules.consoleGamingPreset = {
    imports =
      with inputs.self.nixosModules;
      [
        gaming
        graphicalPreset
        jovian
      ]
      ++ [ inputs.nix-flatpak.nixosModules.nix-flatpak ];
  };

  flake.modules.homeManager.consoleGamingPreset = {
    imports = with inputs.self.modules.homeManager; [
      minimalPreset
      plasma
      emulation
      gaming
    ];
  };
}
