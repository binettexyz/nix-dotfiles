{ inputs, ... }:
{
  flake.modules.homeManager.binettePkgsConfig = {
    imports = with inputs.self.modules.homeManager; [
      binetteShell
      binetteLibrewolf
      binetteQutebrowser
      binetteMpv
      binetteNewsboat
      binetteYazi
      binetteLF
      binetteNeovim
      binetteFoot
      binetteGit
    ];
  };
}
