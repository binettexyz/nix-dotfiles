{ inputs, ... }:
{
  flake.nixosModules.laptopPreset = {
    imports = with inputs.self.nixosModules; [
      battery
      graphicalPreset
      lid
      power
      thinkfan
    ];
  };
}
