{ inputs, ... }:
{
  flake.modules.homeManager.ouryuuBinette = {
    imports = with inputs.self.modules.homeManager; [
      binettePkgsConfig
      minimalPreset
    ];
  };
}
