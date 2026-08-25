{ inputs, ... }:
let
  host = "torii";
in
{
  flake.modules.homeManager.${host} = {
    imports = with inputs.self.modules.homeManager; [
      binettePkgsConfig
    ];
  };
}
