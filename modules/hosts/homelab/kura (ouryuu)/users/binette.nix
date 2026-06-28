{ inputs, ... }:
let
  host = "kura";
in
{
  flake.modules.homeManager."${host}Binette" = {
    imports = with inputs.self.modules.homeManager; [
      binetteShell
      binetteYazi
      binetteTmux
      binetteNeovim
      minimalPreset
    ];
  };
}
