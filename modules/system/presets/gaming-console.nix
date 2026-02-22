{ inputs, ... }:
{
  flake.nixosModules.consoleGamingPreset = {
    imports =
      with inputs.self.nixosModules;
      [
        desktopGamingPreset
        jovian
      ]
      ++ [ inputs.nix-flatpak.nixosModules.nix-flatpak ];
  };

  flake.modules.homeManager.consoleGamingPreset = {
    imports = with inputs.self.modules.homeManager; [
      colorScheme
      minimalPreset
      plasma
      emulation
    ];
  };
}
