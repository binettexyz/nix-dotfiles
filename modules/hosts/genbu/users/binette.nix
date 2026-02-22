{ inputs, ... }:
{
  flake.modules.homeManager.genbu = {
    imports = with inputs.self.modules.homeManager; [
      binettePkgsConfig
    ];
  };
}
