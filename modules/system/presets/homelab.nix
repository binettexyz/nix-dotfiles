{ inputs, ... }:
{
  flake.nixosModules.homelabPreset = {
    imports = with inputs.self.nixosModules; [
      minimalPreset
      homelab
    ];
  };
}
