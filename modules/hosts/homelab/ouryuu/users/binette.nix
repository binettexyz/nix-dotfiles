{ inputs, ... }:
{
  flake.modules.homeManager.ouryuuBinette = {
    imports = with inputs.self.modules.homeManager; [
      binetteShell
      binetteYazi
      binetteTmux
      #binetteNeovim
      minimalPreset
    ];
  };
}
